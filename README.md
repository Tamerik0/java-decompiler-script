# Java Decompiler Script

Cross-platform PowerShell launcher for FernFlower Java decompiler with configuration management.

## Features

- **Cross-platform compatibility**: Works on Windows, Linux, and macOS
- **IntelliJ IDEA integration**: Automatically finds java-decompiler.jar in IntelliJ installation
- **Configuration management**: Save and reuse decompiler paths and settings
- **Flexible usage**: Command-line parameters or interactive configuration
- **Comprehensive testing**: All functions validated with real JAR files

## Usage

### Basic Decompilation
`powershell
# Decompile a single .class file
.\decompiler.ps1 -input MyClass.class -out MyClass.java

# Decompile entire JAR to directory
.\decompiler.ps1 -input myapp.jar -dir output/
`

### Configuration Management
`powershell
# Set IntelliJ IDEA path
.\decompiler.ps1 -SetConfig -i "C:\Program Files\JetBrains\IntelliJ IDEA 2025.1.3"

# Set direct decompiler path
.\decompiler.ps1 -SetConfig -d "C:\path\to\java-decompiler.jar"

# View current configuration
.\decompiler.ps1 -GetConfig

# Clear configuration
.\decompiler.ps1 -ClearConfig
`

### Advanced Usage
`powershell
# With extra decompiler arguments
.\decompiler.ps1 -input app.jar -dir output/ -ExtraArgs "-dgs=1 -rsy=1"

# Interactive configuration mode
.\decompiler.ps1 -SetConfig
`

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
