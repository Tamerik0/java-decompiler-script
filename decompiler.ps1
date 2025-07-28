#!/bin/bash
# 2>/dev/null; PS1="DummyPS1> "; :
# vim: syntax=ps1
<#
:; if command -v pwsh &> /dev/null; then
:;     exec pwsh -Command "$0" "$@"
:; else
:;     exec powershell -NoProfile -Command "$0" "$@"
:; fi
:; exit 0
#>

param(
    [Alias("i")][string]$IdeaPath,
    [Alias("d")][string]$DecompilerPath,
    [Alias("input")][string]$InputFile,
    [Alias("out")][string]$OutputFile,
    [Alias("dir")][string]$OutputDir,
    [Alias("h")][switch]$Help,
    [switch]$SetConfig,
    [switch]$RemoveConfig,
    [switch]$ClearConfig,
    [switch]$GetConfig,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$ExtraArgs
)

function Show-Help {
    Write-Host @"
Java Decompiler Launcher (Cross-Platform)

Usage:
  ./decompile [options]

Main Options:
  -i, -IdeaPath        Path to IntelliJ IDEA installation
  -d, -DecompilerPath  Direct path to java-decompiler.jar
  -input, -InputFile   Input file to decompile
  -out, -OutputFile    Output file path (.java) - for single class files
  -dir, -OutputDir     Output directory for decompiled files
  -h, -Help            Show this help message
  --                   Pass additional arguments to decompiler

Config Management:
  -SetConfig           Set config values (use with -i/-d parameters) or enter interactive mode
  -RemoveConfig        Remove config entries interactively
  -ClearConfig         Clear entire configuration
  -GetConfig           Show current configuration

Output Handling:
  For .class files: 
    -OutputFile specifies the exact output .java file
    -OutputDir specifies the directory for the output file
  For .jar/.zip files:
    -OutputFile is ignored
    -OutputDir specifies the directory for decompiled files

Examples:
  # Decompile single class
  .\decompiler.ps1 -input input.class -out output.java
  
  # Decompile JAR to directory
  .\decompiler.ps1 -input input.jar -dir out/
  
  # With IDEA path
  .\decompiler.ps1 -i ~/idea-IC -input input.jar -dir out
  
  # Set config values
  .\decompiler.ps1 -SetConfig -i "C:\Program Files\JetBrains\IntelliJ IDEA 2025.1.3"
"@
}

function Get-ScriptDirectory {
    # Надежный способ получения пути к скрипту
    if ($PSCommandPath) {
        return Split-Path -Parent $PSCommandPath
    }
    elseif ($MyInvocation.MyCommand.Path) {
        return Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    else {
        return $PWD.Path
    }
}

function Get-ConfigPath {
    $scriptDir = Get-ScriptDirectory
    Join-Path $scriptDir "config.txt"
}

function Read-Config {
    $configPath = Get-ConfigPath
    $config = @{}
    if (Test-Path $configPath) {
        Get-Content $configPath | ForEach-Object {
            if ($_ -match "^\s*([^=]+)=(.*)\s*$") {
                $config[$matches[1]] = $matches[2].Trim()
            }
        }
    }
    return $config
}

function Write-Config {
    param($config)
    $configPath = Get-ConfigPath
    $config.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$($_.Value)"
    } | Set-Content $configPath
}

function Edit-Config {
    param(
        [string]$IdeaPathValue,
        [string]$DecompilerPathValue
    )
    
    $config = Read-Config
    $updated = $false
    
    # Set IdeaPath if provided
    if ($IdeaPathValue) {
        $config["IdeaPath"] = $IdeaPathValue
        Write-Host "Config updated: IdeaPath=$IdeaPathValue"
        $updated = $true
    }
    
    # Set DecompilerPath if provided
    if ($DecompilerPathValue) {
        $config["DecompilerPath"] = $DecompilerPathValue
        Write-Host "Config updated: DecompilerPath=$DecompilerPathValue"
        $updated = $true
    }
    
    # If no parameters provided, fall back to interactive mode
    if (-not $updated) {
        $key = Read-Host "Enter config key to set (e.g. 'dgs')"
        $value = Read-Host "Enter value for '$key' (current: '$($config[$key])')"
        $config[$key] = $value
        Write-Host "Config updated: $key=$value"
        $updated = $true
    }
    
    if ($updated) {
        Write-Config $config
    }
}

function Remove-Config {
    $config = Read-Config
    if ($config.Count -eq 0) {
        Write-Host "Config is already empty"
        return
    }
    
    Write-Host "Current config:"
    $config.GetEnumerator() | ForEach-Object { Write-Host "  $($_.Key)=$($_.Value)" }
    
    $key = Read-Host "Enter key to remove (or 'cancel')"
    if ($key -eq "cancel") { return }
    
    if ($config.ContainsKey($key)) {
        $config.Remove($key)
        Write-Config $config
        Write-Host "Removed '$key' from config"
    }
    else {
        Write-Host "Key '$key' not found in config"
    }
}

function Clear-Config {
    $configPath = Get-ConfigPath
    if (Test-Path $configPath) {
        Remove-Item $configPath -Force
        Write-Host "Config cleared"
    }
    else {
        Write-Host "Config already empty"
    }
}

function Show-Config {
    $config = Read-Config
    if ($config.Count -eq 0) {
        Write-Host "No config entries"
        return
    }
    Write-Host "Current configuration:"
    $config.GetEnumerator() | ForEach-Object {
        Write-Host "  $($_.Key)=$($_.Value)"
    }
}

# Handle config commands first
if ($GetConfig) {
    Show-Config
    exit 0
}

if ($ClearConfig) {
    Clear-Config
    exit 0
}

if ($SetConfig) {
    Edit-Config -IdeaPathValue $IdeaPath -DecompilerPathValue $DecompilerPath
    exit 0
}

if ($RemoveConfig) {
    Remove-Config
    exit 0
}

# Show help if requested
if ($Help -or $args -contains '-?' -or $args -contains '--help') {
    Show-Help
    exit 0
}

# Validate required parameters
if (-not $InputFile) {
    Write-Error "InputFile is required"
    Show-Help
    exit 1
}

# Check if Java is available
try {
    $javaVersion = & java -version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Java not found"
    }
} catch {
    Write-Error "Java is not installed or not in PATH"
    exit 1
}

# Load config and use it as defaults
$config = Read-Config

# Use config values as defaults if parameters not provided
if (-not $IdeaPath -and $config.ContainsKey("IdeaPath")) {
    $IdeaPath = $config["IdeaPath"]
}
if (-not $DecompilerPath -and $config.ContainsKey("DecompilerPath")) {
    $DecompilerPath = $config["DecompilerPath"]
}

if (-not $IdeaPath -and -not $DecompilerPath) {
    Write-Error "You must specify either -IdeaPath or -DecompilerPath (or set in config)"
    Show-Help
    exit 1
}

# Check input file exists
if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit 1
}

# Resolve decompiler path
if ($IdeaPath) {
    $jarPath = Join-Path $IdeaPath "plugins/java-decompiler/lib/java-decompiler.jar"
}
else {
    $jarPath = $DecompilerPath
}

# Verify decompiler exists
if (-not (Test-Path $jarPath)) {
    Write-Error "Decompiler not found at: $jarPath"
    exit 1
}

# Determine output handling based on input type
$inputExtension = [IO.Path]::GetExtension($InputFile).ToLower()
$isArchive = @(".jar", ".zip", ".war", ".ear") -contains $inputExtension

# FernFlower always expects a destination directory, not a file
if ($isArchive) {
    # For archives, use OutputDir directly
    if (-not $OutputDir) {
        $OutputDir = "."
    }
    $destPath = $OutputDir
}
else {
    # For single files (.class), we need to create a temp directory
    # and then move/rename the result if OutputFile is specified
    if ($OutputDir) {
        $destPath = $OutputDir
    } else {
        $destPath = "."
    }
}

# Create destination directory if needed
if (-not (Test-Path $destPath)) {
    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
}

# Read config and merge with command-line arguments
$configArgs = @()

foreach ($key in $config.Keys) {
    # Skip paths that are already used as parameters
    if ($key -eq "IdeaPath" -or $key -eq "DecompilerPath") {
        continue
    }
    $configArgs += "-$key=$($config[$key])"
}

$finalArgs = $configArgs + $ExtraArgs

# Execute decompiler
try {
    Write-Host "Decompiling $InputFile to $destPath"
    
    # Build command arguments properly
    $javaArgs = @(
        "-cp", $jarPath,
        "org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler"
    )
    
    # Add config and extra arguments
    if ($finalArgs) {
        $javaArgs += $finalArgs
    }
    
    # Add input and output
    $javaArgs += @($InputFile, $destPath)
    
    Write-Host "Command: java $($javaArgs -join ' ')"
    Write-Host "Working directory: $(Get-Location)"
    Write-Host "Jar exists: $(Test-Path $jarPath)"
    Write-Host "Input exists: $(Test-Path $InputFile)"
    Write-Host "Destination dir: $destPath"
    
    # Execute with proper argument handling
    try {
        $output = & java @javaArgs 2>&1
        $exitCode = $LASTEXITCODE
        
        if ($exitCode -ne 0) {
            Write-Host "Process output:"
            $output | ForEach-Object { Write-Host $_ }
            Write-Error "Decompilation failed with exit code $exitCode"
            exit $exitCode
        }
        
        # Show output for debugging
        if ($output) {
            $output | ForEach-Object { Write-Host $_ }
        }
        
    } catch {
        Write-Error "Execution error: $_"
        exit 1
    }
    
    Write-Host "Decompilation completed successfully"
    
    # Handle result for single class files
    if (-not $isArchive -and $OutputFile) {
        # Find the decompiled .java file and rename it
        $inputBaseName = [IO.Path]::GetFileNameWithoutExtension($InputFile)
        $decompiled = Get-ChildItem -Path $destPath -Filter "*.java" | Where-Object { $_.BaseName -eq $inputBaseName }
        
        if ($decompiled) {
            $targetPath = if ($OutputDir) { Join-Path $OutputDir $OutputFile } else { $OutputFile }
            Move-Item $decompiled.FullName $targetPath -Force
            Write-Host "Created output file: $targetPath"
        } else {
            Write-Warning "Could not find decompiled file for $inputBaseName"
        }
    }
    
    # Show result info
    if ($isArchive) {
        $decompiled = Get-ChildItem -Path $destPath -Recurse -File -ErrorAction SilentlyContinue
        Write-Host "Decompiled $($decompiled.Count) files to directory: $destPath"
    } else {
        if (-not $OutputFile) {
            # Show files created in destination
            $decompiled = Get-ChildItem -Path $destPath -Filter "*.java" -ErrorAction SilentlyContinue
            if ($decompiled) {
                Write-Host "Created files in $destPath`: $($decompiled.Name -join ', ')"
            }
        }
    }
}
catch {
    Write-Error "Execution error: $_"
    exit 1
}