# File Sorter Bash Script

## Overview
This bash script helps you sort files from a source folder into a destination folder, based on the date the files were created. The destination folder will contain subfolders sorting the files in a single folder with the date as the folder name, or a folder tree with the date split into year, month, and day as subdirectories.

## Usage
1. Make the script executable by running `chmod +x sort-files-by-date.sh`
2. Run the script by typing `./sort-files-by-date.sh` in the terminal
3. Enter the path of the source folder when prompted
4. Enter the path of the destination folder when prompted. If the destination folder doesn't exist, you will be prompted to create it.
5. Choose the format for the destination folder (single folder or folder tree)
6. Wait for the script to finish sorting the files.

## Implementation Details
- The `percentage_calc` function calculates the percentage of completion based on the current file number and the total number of files in the source folder.
- The `progress_bar` function displays a progress bar with the percentage of completion and the name of the current file being processed.
- The script checks if the source folder and the destination folder exist. If the destination folder doesn't exist, the user will be prompted to create it.
- The date of each file is extracted using the `stat` command and the `cut` command.
- Based on the selected format for the destination folder, the script creates the subdirectories for each file and copies the file into the appropriate subdirectory.

## Example 
Suppose we have a source folder /home/user/pictures with the following files:
```
/home/user/pictures/pic1.jpg (modification date: 2022-01-01)
/home/user/pictures/pic2.jpg (modification date: 2022-01-02)
/home/user/pictures/pic3.jpg (modification date: 2022-02-01)
```
And the destination folder is /home/user/sorted_pictures, with format option 2 (folder tree).

After running the script, the destination folder will contain the following files:
```
/home/user/sorted_pictures/2022/01/01/pic1.jpg
/home/user/sorted_pictures/2022/01/02/pic2.jpg
/home/user/sorted_pictures/2022/02/01/pic3.jpg
```


## Conclusion
This script provides a convenient way to sort files based on their modification date, with the option to choose the format for the destination folder.
