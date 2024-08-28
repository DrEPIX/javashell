# Define variables
$githubUrl = "https://github.com/DrEPIX/javashell/archive/refs/tags/alpha.zip"
$downloadPath = "$env:TEMP\yourfile.zip"
$extractPath = "$env:TEMP\setupfiles"
$parentDir = "$extractPath\.."  # Parent directory of the extracted ZIP content
$envVarName1 = "JAVA_HOME"
$envVarValue1 = "C:\Program Files\Java\jdk-22"

# Paths to the logo and setup files in the parent directory of the extracted ZIP
$logoPath = "$parentDir\logo.txt"
$settingsJsonPath = "$parentDir\settings.json"
$tasksJsonPath = "$parentDir\tasks.json"
$launchJsonPath = "$parentDir\launch.json"

# Define paths for VS Code configuration files
$vscodeDir = "$env:APPDATA\Code\User"
$settingsJson = "$vscodeDir\settings.json"
$tasksJson = "$vscodeDir\tasks.json"
$launchJson = "$vscodeDir\launch.json"

# Define workspace structure
$userWorkspaceDir = "$env:USERPROFILE\Workspace"
$binDir = "$userWorkspaceDir\bin"
$srcDir = "$userWorkspaceDir\src"

# Function to clean up
function Cleanup {
    Remove-Item -Path $downloadPath -ErrorAction SilentlyContinue
    Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
}

# Ensure VS Code configuration directory exists
if (-not (Test-Path $vscodeDir)) {
    New-Item -ItemType Directory -Path $vscodeDir -Force
}

# Print logo from the parent directory of the extracted files
if (Test-Path $logoPath) {
    Get-Content -Path $logoPath | Write-Host
}

# Download the file
Invoke-WebRequest -Uri $githubUrl -OutFile $downloadPath

# Extract the file
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Overwrite VS Code configuration files from the parent directory of the extracted files
Copy-Item -Path $settingsJsonPath -Destination $settingsJson -Force
Copy-Item -Path $tasksJsonPath -Destination $tasksJson -Force
Copy-Item -Path $launchJsonPath -Destination $launchJson -Force

# Create workspace structure
New-Item -ItemType Directory -Path $userWorkspaceDir, $binDir, $srcDir -Force

# Set up user environment variables
[System.Environment]::SetEnvironmentVariable($envVarName1, $envVarValue1, [System.EnvironmentVariableTarget]::User)

# Schedule cleanup to run upon exit
Register-EngineEvent PowerShell.Exiting -Action { Cleanup }

# Exit the script
exit
