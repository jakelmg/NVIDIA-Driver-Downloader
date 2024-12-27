# Define the GitHub raw URL of the main script
$MainScriptUrl = "https://raw.githubusercontent.com/jakelmg/NVIDIA-Driver-Downloader/refs/heads/main/driver_installer.ps1"

# Define the download directory in the same location as the PS script
$MainScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$MainScriptRoot = Join-Path $MainScriptDir 'NVIDIA Driver Downloader'

# Create the folder we just defined if it doesn't exist so we can download the main updater script
Write-Host "Creating download folder at: $MainScriptRoot"
if (!(Test-Path $MainScriptRoot)) {
    New-Item -ItemType Directory -Path $MainScriptRoot | Out-Null
}

$MainScriptPath = Join-Path $MainScriptRoot 'driver_installer.ps1'

# Download the main script
Write-Output "Downloading NVIDIA install script from $MainScriptUrl to $MainScriptRoot"
Invoke-WebRequest -Uri $MainScriptUrl -OutFile $MainScriptPath -UseBasicParsing

# Run the downloaded script as admin
Write-Output "Running the main script..."
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$MainScriptPath';`"";
    exit;
}

PowerShell -ExecutionPolicy Bypass -File $MainScriptPath