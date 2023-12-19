$drive = "C:\"

# Get all folders in the root directory of the D drive
$folders = Get-ChildItem -Path $drive -Directory

# Iterate through each folder to calculate its size using robocopy
foreach ($folder in $folders) {
    $folderPath = Join-Path -Path $drive -ChildPath $folder.Name
    $folderSize = robocopy /l /e /nfl /ndl /njh /nc /ns /np /bytes $folderPath $folderPath | Out-String
    $sizeFormatted = $folderSize -replace '\s+',' ' -split(' ') | Where-Object {$_ -match '^\d+$'} | Measure-Object -Sum | ForEach-Object { $_.Sum / 1GB }
    $sizeFormatted = "{0:N2}" -f $sizeFormatted
    Write-Host "$($folder.Name): $sizeFormatted GB"
}
