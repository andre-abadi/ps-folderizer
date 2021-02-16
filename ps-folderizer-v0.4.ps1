# By Andre Abadi



# treat all non-terminating errors as terminating errors
$ErrorActionPreference = "STOP"

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

# pre-output
echo "The following files were copied:"
echo "==============================================="


# start a counter for number of files copied
$counter = 0

# get all files in the directory referenced by the $documents variable
$children = Get-ChildItem -Path $thisDir -Recurse -File

# regex all files and store all hits
$regexHits = echo $children | Where-Object {$_.Name -match '(.{3})\.(\d{4})\.(\d{4})\.(\d{4})'}

# initiate an empty arraylist to hold copied files
$filesCopied = [System.Collections.ArrayList]@()

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

        # add filename to copied files ArrayList
        $filesCopied.Add($hitFileName) | Out-Null        

        # 'touch' to automatically create folders
        New-Item -ItemType File -Path $destination -Force | Out-Null

        # copy the item to that place
        Copy-Item -Path "$($hit.FullName)" -Destination $destination -Force | Out-Null #-Force
    }
}

# post-output
echo "==============================================="

# report total copied files
echo "Finished. Copied a total of $($counter) files."

# create and populate log if any files copied
if ($filesCopied.Count -gt 0)
{
    # set a name for the log file
    $logName = "folderized-files.txt"
    $logPath = "$($thisDir)\$($logName)"

    # clear any existing logs if they exist
    if (Test-Path $logPath)
    {
        Remove-Item -Path $logPath -Force | Out-Null
        echo "`nDeleted old '$($logName)'."
    }

    # sort ArrayList alphabetically
    $filesCopied.Sort()
    
    # iterate through ArrayList
    foreach ($instance in $filesCopied)
    {
        # and append to log
        Add-Content -Path $logPath -Value $instance
    }

    # report file listing creation
    echo "`nMade a listing of copied files in '$($logName)'"

}

# ending bits
Read-Host "`nPress ENTER to exit"
