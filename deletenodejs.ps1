# Define the folder path to delete
$folderPath = "C:\Path\To\Your\Folder"

# Check if the folder exists
if (Test-Path -Path $folderPath) {
    try {
        # Remove the folder and its contents
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Output "The folder and its contents were successfully deleted."
    } catch {
        Write-Error "An error occurred while trying to delete the folder: $_"
    }
} else {
    Write-Output "The specified folder does not exist."
}
