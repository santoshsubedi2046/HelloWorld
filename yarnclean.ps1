$filePath = "D:\runner\runner_status.txt"
$cacheFolder = "D:\yarn_cache\0"
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

# Check if the file exists
if (Test-Path $filePath) {
    try {
        $content = Get-Content $filePath
        $freeSpacePercentage = Get-FreeDiskSpacePercentage
        if ($content -match "LOW_DISK_SPACE=true" -and $freeSpacePercentage -lt 25) {
            # If both conditions are met, execute yarn cache clean command
            Write-Host "Low disk space detected (Free space: $freeSpacePercentage%). Cleaning yarn cache..."
            $yarnCleanProcess = Start-Process -FilePath "yarn" -ArgumentList "cache", "clean", "--cache-folder=$cacheFolder" -PassThru -Wait -NoNewWindow
            $exitCode = $yarnCleanProcess.ExitCode
            if ($exitCode -eq 0) {
                Write-Host "Yarn cache cleaned successfully."
            } else {
                Write-Host "Yarn cache clean failed with exit code: $exitCode"
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
