# By Andre Abadi


# starting bits & info
echo "`nFolderizer by Andre Abadi.`n"
echo "  Recurses this and all subdirectories"
echo "  and finds all files with Bates numbers."
echo "  EG: ABC.0001.0001.0001.pdf`n"
echo "  **COPIES** them in folders for Ringtail"
echo "  based on their Bates numbering in filename."
echo "  EG: ABC/0001/0001/ABC.0001.0001.0001.pdf`n"

# global variable for referencing current folder
$thisDir = Get-Location

# pre-output
echo "The following files were copied:"
echo "==============================================="


# get all files
$children = Get-ChildItem -Recurse -File

# start a counter
$counter = 0


# regex all files and store all hits
$regexHits = echo $children | Where-Object {$_.Name -match '(.{3})\.(\d{4})\.(\d{4})\.(\d{4})'}

# iterate through all hits
foreach ($hit in $regexHits)
{
    # get just the filename from the full source path
    $hitFileName = Split-Path $hit -leaf

    echo $hit

    # run fresh regex for per-hit grouping
    $hit -match '(.{3})\.(\d{4})\.(\d{4})\.(\d{4})' | Out-Null
    
    echo $hit

    # create full destination path using regex matches for folder names
    $destination = "$($thisDir)\$($Matches[1])\$($Matches[2])\$($Matches[3])\$($hitFileName)"
    
    # only copy if it doesn't yet exist
    if (-Not (Test-Path $destination))
    {

        # increment the counter
        $counter = $counter + 1
        
        # output the name of the file
        echo $hitFileName

        # 'touch' to automatically create folders
        New-Item -ItemType File -Path $destination -Force | Out-Null

        # copy the item to that place
        Copy-Item $hit $destination | Out-Null #-Force
    }
}

# post-output
echo "==============================================="

# report total copied files
echo "`nFinished"
echo "Copied $($counter) files."

# ending bits
Read-Host "Press ENTER to exit"
