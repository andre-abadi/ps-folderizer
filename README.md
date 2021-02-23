# ps-folderizer
PowerShell eDiscovery Automatic Folderizer for Ringtail/NUIX Discover Imports

# Description
PowerShell script that recursively scans subdirectories for filenames matching Australian legal Bates numbering sequences, and copies those files into nested folders according to their filename structure.

# Function
1. Recurses all files and folders alongside this script
2. Finds all files with Bates numbers
    - EG: `ABC.0001.0001.0001.pdf`
3. Copies them into folders according to their Bates number
    - EG: `ABC/0001/0001/ABC.0001.0001.0001.pdf`
4. Provides output log as a text file alongside script
