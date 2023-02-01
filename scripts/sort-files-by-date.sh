#!/bin/bash

# This script allows the user to sort all the files in a source folder into new folders,
# organized by the file datetime, under a year/month/day tree structure or in a single folder.
# The user inputs the origin and destination folders, and selects the format for the final folder.
# The script also displays the progress bar with the copy action for each file in the same line.

clear


# Function to calculate the percentage of the current file being processed
# Parameter: actual value and total values
function percentage_calc() {
  # Get the actual value (current file number) and total values (total number of files)
  local actual_value="$1"
  local total_values="$2"

  # Calculate the percentage of the current file being processed
  local percent_calc
  percent_calc=$((actual_value * 100 / total_values))
  
  # Return the percentage
  echo "$percent_calc"
}


# Function to display the progress bar
# Parameter: percentage completed and text message
function progress_bar() {
  # Get the width of the progress bar and the percentage completed
  local w=80 p="$1"; shift

  # Create the dots string that represents the progress
  printf -v dots "%*s" "$((p * w / 100))" ""; dots="${dots// /.}"
  
  # Print the progress bar with the percentage completed and the message
  printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"
}


# Read the source folder from the user
read -p "Enter the source folder: " src_dir
# Check if the source folder exists
if [ ! -d "$src_dir" ]; then
  # If not, show an error message and exit the script
  echo "Error: the source folder doesn't exist."
  exit 1
fi


# Read the destination folder from the user
read -p "Enter the destination folder: " dst_dir
# Check if the destination folder exists
if [ ! -d "$dst_dir" ]; then
  # If not, ask the user if they want to create it
  read -p "Folder not found. Do you want to create it? (y/n): " create_dst_dir_answer
  if [ "$create_dst_dir_answer" == "y" ]; then
    # If the answer is "y", create the folder
    mkdir "$dst_dir"
    echo "Folder created."
  else
    # If the answer is not "y", show a message and exit the script
    echo "Exiting."
    exit 1
  fi
fi


# Ask the user about the format of the final folder
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
    # If option choosed is none of the given, show a message and exit the script
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac
echo


# Initialize counters
total_of_files_in_src_dir=$(find "$src_dir" -type f | wc -l)
current_file_number=0


# Loop through each file in the source directory
for file in "$src_dir"/*; do
  let current_file_number++
  
  # Get the file modification time
  file_date=$(stat -c %y "$file" | cut -d ' ' -f 1)

  # Set the final destination subdirectory name
  case "$dst_dir_format_choice" in
    1)
      format_dir="$file_date"
      ;;
    2)
      # Extract the year, month, and day from the modification time
      year=$(echo "$file_date" | cut -d '-' -f 1)
      month=$(echo "$file_date" | cut -d '-' -f 2)
      day=$(echo "$file_date" | cut -d '-' -f 3)
      format_dir="$year/$month/$day"
      ;;
  esac
  subdir="$dst_dir/$format_dir"

  # Create the destination subdirectory if it does not exist	
  mkdir -p "$subdir"

  # Show progress bar
  filename=$(basename "$file")
  current_percent=$(percentage_calc "$current_file_number" "$total_of_files_in_src_dir")
  progress_bar "$current_percent" "$filename"

  # Copy the file to the destination subdirectory
  cp "$file" "$subdir"
done


# All files have been sorted  
echo
echo "Finished sorting files."
echo