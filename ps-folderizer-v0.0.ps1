# FlatPacker
# By Andre Abadi

# MOTD

echo ""
echo "FlatPacker, by Andre Abadi"
echo "    Option 1 'Folderize':"
echo "        From '\Documents\ABC.0001.0001.0001.pdf'"
echo "             '\Documents\ABC.0002.0001.0001.pdf'"
echo "             '\Documents\ABC.0002.0002.0001.pdf'"
echo "        To   '\ABC\0001\0001\ABC.0001.0001.0001.pdf'"
echo "             '\ABC\0002\0001\ABC.0002.0001.0001.pdf'"
echo "             '\ABC\0002\0002\ABC.0002.0002.0001.pdf'"
echo "    Option 2 'Flatten':"
echo "        From '\ABC\0001\0001\ABC.0001.0001.0001.pdf'"
echo "             '\ABC\0002\0001\ABC.0002.0001.0001.pdf'"
echo "             '\ABC\0002\0002\ABC.0002.0002.0001.pdf'"
echo "        To   '\Documents\ABC.0001.0001.0001.pdf'"
echo "             '\Documents\ABC.0002.0001.0001.pdf'"
echo "             '\Documents\ABC.0002.0002.0001.pdf'"
echo ""

# Helper function for time stamp generation
function Get-TimeStamp {
    
    #return "({0:MM/dd/yy} {0:HH:mm:ss})" -f (Get-Date)
    return "{0:yyyy-MM-dd} {0:HH-mm-ss}" -f (Get-Date)
    
}
# Helper function to create empty log file
function touch {set-content -Path ($args[0]) -Value ($null)} 
# Create logfile name
$logfile = "_log_$(Get-Timestamp).txt"
# Get the currect working directory
$pwd = Get-Location
# Create the logfile if it doesn't already exist
touch $logfile
echo "Logging to $pwd\$logfile"
echo ""

#$Choice = $null
#DO
#{
#    $Choice = Read-Host "Press 1 to Folderize or 2 to Flatten"
#} While ($Choice -ne 2 -And $Choice -ne 1)

# All file Ringtail Regex
# (.{3})\.(\d{4})\.(\d{4})\.(\d{4})\.(.*)


Write-Output "($(Get-TimeStamp)) STARTING" | Tee-Object $logfile -append


function folderize {
    $directories = "$(pwd)\Documents"
    foreach ($dir in $directories) {
        Write-Output "Iterating through $(dir)" | Tee-Object $logfile -append
    }
}


function flatten2 {
    $docs = "$(pwd)\Documents\"
    if (!(test-path $docs)) {
        echo "Creating 'Documents' directory..." >> $logfile
        New-Item -ItemType Directory -Force -Path $docs | Tee-Object $logfile -append
    }
    Get-ChildItem -Path $pwd -Exclude "*.ps1" -File -Recurse | Move-Item -Verbose -Exclude "*.ps1" -Destination "$(pwd)\Documents\" *>&1 | Tee-Object $logfile -append
}

flatten2

echo ""
$End = Read-Host "Press ENTER to exit"