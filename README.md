# 🔪 Butcher

<div align="center">

![Version](https://img.shields.io/badge/version-2.0-red.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue.svg)
![License](https://img.shields.io/badge/license-Educational-green.svg)

**Multi-Platform Security Research Toolkit**

*For educational and authorized security testing purposes only*

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture) • [Disclaimer](#-disclaimer)

</div>

---

## ⚠️ DISCLAIMER

**THIS TOOL IS FOR EDUCATIONAL AND AUTHORIZED SECURITY TESTING ONLY**

- ✅ Use only in authorized penetration testing environments
- ✅ Only on systems you own or have explicit written permission to test
- ❌ Unauthorized access to computer systems is illegal
- ❌ The authors are NOT responsible for any misuse or damage
- ❌ Using this tool against systems without permission is a CRIME

**By using this tool, you agree to use it responsibly and legally.**

---

## 📋 Overview

Butcher is a comprehensive security research toolkit designed for penetration testers and security researchers. It provides various capabilities for authorized security assessments across multiple platforms including Linux, macOS, and Windows environments.

### 🎯 Key Capabilities

- **Cross-Platform Support**: Native support for Linux, macOS, and Windows
- **PDF Analysis**: Advanced PDF document processing and analysis
- **Modular Architecture**: Extensible plugin-based design
- **Automated Setup**: One-command installation and configuration
- **Educational Focus**: Built for learning and security research

---

## 🚀 Features

### Core Modules

#### 📄 PDF Robber
Advanced PDF document analysis and extraction toolkit:
- Document metadata extraction
- Embedded file detection and extraction
- JavaScript analysis in PDFs
- Form data extraction
- Password-protected PDF handling

#### 🛠️ Tools Suite
Comprehensive collection of security utilities:
- Network reconnaissance tools
- Protocol analyzers
- Data extraction utilities
- System enumeration capabilities
- Custom payload generators

#### ⚙️ Settings Module
Flexible configuration system:
- Per-platform customization
- Profile management
- Output formatting options
- Logging configuration
- Environment variables

---

## 📦 Installation

### Prerequisites

**Linux / macOS:**
```bash
# Required packages
- bash >= 4.0
- python3 >= 3.8
- git
```

**Windows:**
```powershell
# Required software
- Windows 10/11
- PowerShell 5.1+
- Python 3.8+
```

### Quick Start

#### Linux / macOS

```bash
# Clone the repository
git clone https://github.com/TheDeepOpc/butcher.git
cd butcher

# Make setup script executable
chmod +x setup.sh

# Run automated setup
./setup.sh

# Verify installation
./physical.sh --version
```

#### Windows

```powershell
# Clone the repository
git clone https://github.com/TheDeepOpc/butcher.git
cd butcher

# Run setup
.\setup.bat

# Verify installation
.\physical.bat --version
```

### Manual Installation

```bash
# Install Python dependencies
pip install -r requirements.txt

# Configure environment
cp settings/config.example.conf settings/config.conf

# Edit configuration
nano settings/config.conf

# Initialize toolkit
./setup.sh --manual
```

---

## 🎮 Usage

### Basic Commands

```bash
# Display help menu
./physical.sh --help

# Run in interactive mode
./physical.sh --interactive

# Specify target (authorized only!)
./physical.sh --target <authorized-system>

# Use specific module
./physical.sh --module pdf-robber

# Run with custom config
./physical.sh --config settings/custom.conf
```

### Advanced Usage

#### PDF Analysis

```bash
# Analyze PDF document
./physical.sh --module pdf-robber --file document.pdf

# Extract embedded files
./physical.sh --module pdf-robber --extract --file document.pdf

# Analyze JavaScript in PDF
./physical.sh --module pdf-robber --js-analysis --file document.pdf

# Batch processing
./physical.sh --module pdf-robber --batch --directory ./pdf_samples/
```

#### Custom Modules

```bash
# List available modules
./physical.sh --list-modules

# Load custom module
./physical.sh --load-module tools/custom_module.py

# Run with specific tools
./physical.sh --tools "recon,enum,extract"
```

#### Output Options

```bash
# Save results to file
./physical.sh --output results.txt

# JSON format
./physical.sh --format json --output results.json

# Verbose mode
./physical.sh --verbose

# Silent mode (logs only)
./physical.sh --silent --log-file operation.log
```

---

## 🏗️ Architecture

```
butcher/
├── aboutmalware/          # Malware analysis documentation
│   ├── techniques.md      # Attack techniques reference
│   ├── indicators.md      # IOC database
│   └── samples/           # Educational malware samples
├── settings/              # Configuration files
│   ├── config.conf        # Main configuration
│   ├── profiles/          # User profiles
│   └── templates/         # Output templates
├── tools/                 # Core utilities
│   ├── pdf_robber/        # PDF analysis toolkit
│   ├── network/           # Network tools
│   ├── system/            # System utilities
│   └── common/            # Shared libraries
├── setup.sh               # Automated setup script
├── physical.sh            # Main execution script
├── languages.txt          # Supported languages
└── README.md              # This file
```

### Module Structure

Each module follows a standardized structure:

```python
class CustomModule:
    def __init__(self):
        self.name = "Module Name"
        self.version = "1.0"
        self.author = "Your Name"
    
    def run(self, args):
        # Module logic here
        pass
    
    def cleanup(self):
        # Cleanup operations
        pass
```

---

## 🔧 Configuration

### Basic Configuration

Edit `settings/config.conf`:

```ini
[General]
debug_mode = false
log_level = INFO
output_dir = ./output

[PDF-Robber]
extract_embedded = true
analyze_javascript = true
max_file_size = 50MB

[Network]
timeout = 30
retry_attempts = 3
user_agent = Custom-Agent/1.0
```

### Environment Variables

```bash
export BUTCHER_HOME=/path/to/butcher
export BUTCHER_CONFIG=/path/to/config.conf
export BUTCHER_LOG_LEVEL=DEBUG
```

---

## 📚 Documentation

### Available Modules

| Module | Description | Status |
|--------|-------------|--------|
| `pdf-robber` | PDF analysis and extraction | ✅ Active |
| `network-recon` | Network reconnaissance | ✅ Active |
| `system-enum` | System enumeration | ✅ Active |
| `data-extract` | Data extraction utilities | ✅ Active |
| `payload-gen` | Payload generator | 🚧 Beta |

### Language Support

The toolkit supports multiple languages for output and reporting. See `languages.txt` for the full list.

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/AmazingFeature`
3. **Commit your changes**: `git commit -m 'Add some AmazingFeature'`
4. **Push to the branch**: `git push origin feature/AmazingFeature`
5. **Open a Pull Request**

### Code Standards

- Follow PEP 8 for Python code
- Use shellcheck for bash scripts
- Add comments for complex logic
- Update documentation
- Test thoroughly before submitting

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Setup script fails
```bash
# Solution: Check permissions
chmod +x setup.sh
sudo ./setup.sh
```

**Issue**: Module not found
```bash
# Solution: Verify installation
./physical.sh --list-modules
pip install -r requirements.txt
```

**Issue**: Permission denied
```bash
# Solution: Run with appropriate privileges
# For authorized testing only!
sudo ./physical.sh
```

---

## 📊 Project Status

- ✅ Core framework: Complete
- ✅ PDF Robber module: Active
- ✅ Cross-platform support: Stable
- 🚧 Additional modules: In development
- 📝 Documentation: Ongoing updates

---

## 🔐 Security Notice

This tool is intended for:
- **Authorized penetration testing**
- **Security research in controlled environments**
- **Educational purposes in cybersecurity training**
- **Vulnerability assessment with permission**

### Legal Compliance

- Always obtain written authorization before testing
- Comply with local and international laws
- Follow responsible disclosure practices
- Respect privacy and confidentiality
- Document all activities for audit purposes

---

## 📜 License

This project is licensed for **Educational Purposes Only**.

```
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR
ANY CLAIM, DAMAGES OR OTHER LIABILITY ARISING FROM THE USE OF
THE SOFTWARE.
```

---

## 👤 Author

**TheDeepOpc**

- GitHub: [@TheDeepOpc](https://github.com/TheDeepOpc)
- Repository: [butcher](https://github.com/TheDeepOpc/butcher)

---

## 📞 Support

- 📧 Issues: [GitHub Issues](https://github.com/TheDeepOpc/butcher/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/TheDeepOpc/butcher/discussions)
- 📖 Wiki: [Project Wiki](https://github.com/TheDeepOpc/butcher/wiki)

---

## 🙏 Acknowledgments

- Security research community
- Open-source contributors
- Penetration testing frameworks
- Educational institutions supporting cybersecurity research

---

<div align="center">

**Remember: With great power comes great responsibility.**

Use this tool ethically and legally.

⭐ Star this repo if you find it useful!

</div>
