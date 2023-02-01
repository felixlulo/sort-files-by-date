#!/bin/bash

clear

function percentage_calc() {
  local actual_value="$1"
  local total_values="$2"
  local percent_calc
  percent_calc=$((actual_value * 100 / total_values))
  echo "$percent_calc"
}

function progress_bar() {
  local w=80 p="$1"; shift
  printf -v dots "%*s" "$((p * w / 100))" ""; dots="${dots// /.}"
  printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"
}

read -p "Enter the source folder: " src_dir
if [ ! -d "$src_dir" ]; then
  echo "Error: the source folder doesn't exist."
  exit 1
fi

read -p "Enter the destination folder: " dst_dir
if [ ! -d "$dst_dir" ]; then
  read -p "Folder not found. Do you want to create it? (y/n): " create_dst_dir_answer
  if [ "$create_dst_dir_answer" == "y" ]; then
    mkdir "$dst_dir"
    echo "Folder created."
  else
    echo "Exiting."
    exit 1
  fi
fi

echo "Please choose the format for the final folder:"
echo "1. /yyyy-mm-dd/ single folder"
echo "2. /yyyy/mm/dd/ folder tree"
read -p "Enter your choice (1 or 2): " dst_dir_format_choice

case "$dst_dir_format_choice" in
  1)
    echo "Selected the 'Single Folder' format for destination folder"
    ;;
  2)
    echo "Selected the 'Folder Tree' format for destination folder"
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

total_of_files_in_src_dir=$(find "$src_dir" -type f | wc -l)
current_file_number=0
for file in "$src_dir"/*; do
  let current_file_number++
  file_date=$(stat -c %y "$file" | cut -d ' ' -f 1)

  case "$dst_dir_format_choice" in
    1)
      format_dir="$file_date"
      ;;
    2)
      year=$(echo "$file_date" | cut -d '-' -f 1)
      month=$(echo "$file_date" | cut -d '-' -f 2)
      day=$(echo "$file_date" | cut -d '-' -f 3)
      format_dir="$year/$month/$day"
      ;;
  esac
  subdir="$dst_dir/$format_dir"

  mkdir -p "$subdir"

  filename=$(basename "$file")
  current_percent=$(percentage_calc "$current_file_number" "$total_of_files_in_src_dir")
  progress_bar "$current_percent" "$filename"
  cp "$file" "$subdir"
done

  
echo
echo "Finished sorting files."
echo