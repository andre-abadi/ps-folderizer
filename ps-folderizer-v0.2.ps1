# By Andre Abadi


# starting bits & info
echo "`nFolderizer by Andre Abadi.`n"
echo "  Recurses the Documents folder alongside this script"
echo "  and finds all files with Bates numbers."
echo "  EG: ABC.0001.0001.0001.pdf`n"
echo "  COPIES them in folders for Ringtail"
echo "  based on their Bates numbering in filename."
echo "  EG: ABC/0001/0001/ABC.0001.0001.0001.pdf`n"

# global variable for referencing current folder
$thisDir = Get-Location

# reference documents folder
$documents = "$($thisDir)\INPUT"
# get just the name of the $files filename
$documentsName = Split-Path $documents -leaf

if (-Not (Test-Path $documents))
{
    echo "This script looks for files in the 'input' folder"
    echo "  alongside this script. Unable to find 'input' folder.`n"

    New-Item -ItemType Directory -Path $documents -Force | Out-Null

    echo "I've made the '$($documentsName)' folder for you to put files into,"
    echo "  and now quitting for you to put files in there."
    exit
}


# create files.txt
$files = "$($thisDir)\folderized-files.txt"
New-Item -ItemType File -Path $files -Force | Out-Null
# get just the name of the $files filename
$filesName = Split-Path $files -leaf

# check that both files were successfully created
if (-Not (Test-Path $files))
{
    echo "Unable to create necessary '$($filesName)'"
    echo "  alongside this script so cannot proceed. Likely"
    echo "  you don't have write permission to this"
    echo "  directory? Cannot proceed so exiting."
    exit
}

# pre-output
echo "The following files were copied:"
echo "==============================================="


# start a counter for number of files copied
$counter = 0

# get all files in the directory referenced by the $documents variable
$children = Get-ChildItem -Path $documents -Recurse -File

# regex all files and store all hits
$regexHits = echo $children | Where-Object {$_.Name -match '(.{3})\.(\d{4})\.(\d{4})\.(\d{4})'}

# iterate through all hits
foreach ($hit in $regexHits)
{
    # get just the filename from the full source path
    $hitFileName = Split-Path $hit -leaf

    # run fresh regex for per-hit grouping
    $hit -match '(.{3})\.(\d{4})\.(\d{4})\.(\d{4})' | Out-Null

    # create full destination path using regex matches for folder names
    $destination = "$($thisDir)\$($Matches[1])\$($Matches[2])\$($Matches[3])\$($hitFileName)"
    
    # only copy if it doesn't yet exist
    if (-Not (Test-Path $destination))
    {

        # increment the counter
        $counter = $counter + 1
        
        # output the name of the file
        echo $hitFileName

        # append files.txt
        Add-Content -Path $files -Value $hitFileName

        # 'touch' to automatically create folders
        New-Item -ItemType File -Path $destination -Force | Out-Null

        # copy the item to that place
        Copy-Item -Path input\$hit -Destination $destination -Force | Out-Null #-Force
    }
}

# post-output
echo "==============================================="

# report total copied files
echo "`nFinished. Copied a total of $($counter) files."

# delete files.txt if nothing was put in it
if ($counter -eq 0)
{
    Remove-Item -Path $files -Force | Out-Null

} else {

    # report file listing creation
    echo "`nMade a listing of copied files in '$($filesName)'"

}

# ending bits
Read-Host "Press ENTER to exit"
