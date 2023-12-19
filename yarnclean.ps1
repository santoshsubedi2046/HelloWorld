$filePath = "D:\runner\runner_status.txt"
$disk = "D:"

# Function to calculate free disk space percentage
function Get-FreeDiskSpacePercentage {
    $diskInfo = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $disk }
    if ($diskInfo) {
        $freeSpace = $diskInfo.FreeSpace
        $totalSpace = $diskInfo.Size
        $freeSpacePercentage = [math]::Round(($freeSpace / $totalSpace) * 100, 2)
        return $freeSpacePercentage
    }
    return $null
}

$cacheFolders = @(
    "D:\yarn_cache\0",
    "D:\yarn_cache\1",
    "D:\yarn_cache\2",
    "D:\yarn_cache"
)

# Check if the file exists
if (Test-Path $filePath) {
    try {
        $content = Get-Content $filePath
        $freeSpacePercentage = Get-FreeDiskSpacePercentage
        if ($content -match "LOW_DISK_SPACE=true" -and $freeSpacePercentage -lt 25) {
            # If both conditions are met, clean yarn cache in specified folders
            foreach ($cacheFolder in $cacheFolders) {
                try {
                    Write-Host "Cleaning yarn cache in folder: $cacheFolder"
                    $yarnCleanProcess = Start-Process -FilePath "yarn" -ArgumentList "cache", "clean", "--cache-folder=$cacheFolder" -PassThru -Wait -NoNewWindow
                    $exitCode = $yarnCleanProcess.ExitCode
                    if ($exitCode -eq 0) {
                        Write-Host "Yarn cache cleaned successfully in folder: $cacheFolder"
                    } else {
                        Write-Host "Yarn cache clean failed in folder: $cacheFolder with exit code: $exitCode"
                    }
                } catch {
                    Write-Host "Error cleaning yarn cache in folder: $cacheFolder - $_.Exception.Message"
                }
            }
        } else {
            if ($freeSpacePercentage -ge 25) {
                Write-Host "Free disk space ($disk) is greater than or equal to 25%."
            } else {
                Write-Host "LOW_DISK_SPACE is not true or free disk space ($disk) is above 25%."
            }
        }
    } catch {
        Write-Host "Error reading the file: $_.Exception.Message"
    }
} else {
    Write-Host "File not found at $filePath"
}
