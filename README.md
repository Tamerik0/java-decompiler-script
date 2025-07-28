# Java Decompiler Script

Cross-platform PowerShell launcher for FernFlower Java decompiler with configuration management.

## Features

- **Cross-platform compatibility**: Works on Windows, Linux, and macOS
- **IntelliJ IDEA integration**: Automatically finds java-decompiler.jar in IntelliJ installation
- **Configuration management**: Save and reuse decompiler paths and settings
- **Flexible usage**: Command-line parameters or interactive configuration
- **SameDir convenience**: Automatically place output files next to input files
- **Comprehensive testing**: All functions validated with real JAR files

## Usage

### Basic Decompilation

```powershell
# Decompile a single .class file
.\decompiler.ps1 -input MyClass.class -out MyClass.java

# Decompile entire JAR to directory
.\decompiler.ps1 -input myapp.jar -dir output/

# Place output in same directory as input (convenient!)
.\decompiler.ps1 -input myapp.jar -SameDir
.\decompiler.ps1 -input MyClass.class -s
```

### Configuration Management

```powershell
# Set IntelliJ IDEA path
.\decompiler.ps1 -SetConfig -i "C:\Program Files\JetBrains\IntelliJ IDEA 2025.1.3"

# Set direct decompiler path
.\decompiler.ps1 -SetConfig -d "C:\path\to\java-decompiler.jar"

# View current configuration
.\decompiler.ps1 -GetConfig

# Clear configuration
.\decompiler.ps1 -ClearConfig

# Interactive configuration mode
.\decompiler.ps1 -SetConfig
```

### Advanced Usage

```powershell
# With additional decompiler arguments
.\decompiler.ps1 -input app.jar -dir output/ -- -dgs=1 -rsy=1

# Use short parameter aliases
.\decompiler.ps1 -i app.jar -dir out/ -s
```

## Parameters

| Parameter | Alias | Description |
|-----------|-------|-------------|
| `-InputFile` | `-input` | Input file to decompile (.class, .jar, .zip, .war, .ear) |
| `-OutputFile` | `-out` | Output file path (.java) - for single class files |
| `-OutputDir` | `-dir` | Output directory for decompiled files |
| `-SameDir` | `-s` | Place output files in the same directory as input file |
| `-IdeaPath` | `-i` | Path to IntelliJ IDEA installation |
| `-DecompilerPath` | `-d` | Direct path to java-decompiler.jar |
| `-SetConfig` | | Set configuration values |
| `-GetConfig` | | Show current configuration |
| `-ClearConfig` | | Clear entire configuration |
| `-RemoveConfig` | | Remove config entries interactively |
| `-Help` | `-h` | Show help message |

## Requirements

- PowerShell (Windows PowerShell 5.1+ or PowerShell Core 6.0+)
- Java JRE/JDK (must be in PATH)
- IntelliJ IDEA (for automatic detection) OR direct path to java-decompiler.jar

## Development Notes

- **Code developed by**: GitHub Copilot AI Assistant
- **Comprehensive testing**: All functions systematically tested and validated
- **Error handling**: Robust error handling and parameter validation
- **Cross-platform design**: Includes shebang header for Unix-like systems

## License

MIT License - feel free to use and modify as needed.
