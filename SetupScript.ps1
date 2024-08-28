# Define variables
$githubUrl = "https://github.com/username/repository/releases/download/v1.0.0/yourfile.zip"
$downloadPath = "$env:TEMP\yourfile.zip"
$extractPath = "$env:TEMP\setupfiles"
$envVarName1 = "JAVA_HOME"
$envVarValue1 = "C:\Program Files\Java\jdk-22"
$logoPath = "$PSScriptRoot\logo.txt"  # Path to the logo text file

# Function to clean up
function Cleanup {
    Remove-Item -Path $downloadPath -ErrorAction SilentlyContinue
    Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
}

# Print logo from text file
if (Test-Path $logoPath) {
    Get-Content -Path $logoPath | Write-Host
}

# Download the file
Invoke-WebRequest -Uri $githubUrl -OutFile $downloadPath

# Extract the file
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Set up user environment variables
[System.Environment]::SetEnvironmentVariable($envVarName1, $envVarValue1, [System.EnvironmentVariableTarget]::User)
#[System.Environment]::SetEnvironmentVariable($envVarName2, $envVarValue2, [System.EnvironmentVariableTarget]::User)

# Schedule cleanup to run upon exit
Register-EngineEvent PowerShell.Exiting -Action { Cleanup }

# Exit the script
exit
