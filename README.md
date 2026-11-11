# XClang

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![LLVM](https://img.shields.io/badge/Based%20on-LLVM%2023.1.5-orange.svg)](https://llvm.org/)

Pre-compiled Clang Compiler binaries for Android and other platforms.

## Description

XClang is a public repository providing pre-compiled binaries of the Clang compiler built on top of the LLVM Project. This repository contains ready-to-use binaries for various development purposes, particularly for Android kernel and NDK development.

**Note**: This is a binaries-only distribution repository built with Polly (polyhedral loop optimizer) and ThinLTO support.

## Features

- **LLVM/Clang 23.1.5** with Polly loop optimizer integrated (`+Polly`)
- Target architectures: `AArch64`, `ARM`, `X86`
- Complete header files for C/C++ development
- Performance-optimized binaries (Release build, ThinLTO / LLD)
- Ideal for Android Linux Kernel (GKI 5.10, 5.15, 6.1+) and NDK

## Package Contents

```
XClang-23.1.5-Polly.tar.gz  # Compiler binary archive
├── bin/                   # Executable binaries (clang, lld, opt, llvm-*, etc.)
├── include/               # Header files (clang, llvm, lld, polly)
│   ├── clang/             # Clang headers
│   ├── lld/               # LLD linker headers
│   ├── llvm/              # LLVM core headers
│   └── polly/             # Polly optimizer headers
└── lib/                   # Libraries (.a and .so runtimes)
```

## Installation

### Download

Download the release archive from the [Releases page](https://github.com/Steambot12/XClang-Binaries/releases).

```bash
curl -L -o XClang-23.1.5-Polly.tar.gz https://github.com/Steambot12/XClang-Binaries/releases/download/xclangpolly-23.1.5/XClang-23.1.5-Polly.tar.gz
tar -xzf XClang-23.1.5-Polly.tar.gz -C /path/to/xclang-23
```

### Add to PATH (Optional)

```bash
export PATH=$PATH:/path/to/xclang-23/bin
```

Or add to `~/.bashrc` or `~/.zshrc` for permanent setup:

```bash
echo 'export PATH=$PATH:/path/to/xclang-23/bin' >> ~/.bashrc
source ~/.bashrc
```

## Usage

### Compile C File

```bash
clang -o output program.c
```

### Compile with Polly Loop Optimization

```bash
clang -O3 -mllvm -polly program.c -o output
```

### Cross-compile for Android (AArch64)

```bash
clang --target=aarch64-linux-gnu -O2 -o output program.c
```

## System Requirements

- Linux (x86_64)
- Minimum 2GB RAM
- 2.5GB free disk space

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for complete details.

See [NOTICE](NOTICE) file for complete LLVM licensing information.

## Credits and Attribution

### LLVM Project
- **Website**: https://llvm.org/
- **Repository**: https://github.com/llvm/llvm-project
- **Version**: 23.1.5 (`392dfff97d29b59d77e5cac6d4b6ef2585fe7117`)

### Acknowledgments
- The LLVM Team and contributors
- Xtra Manager Software & Steambot12 Community

## Version Information

- **Compiler**: XClang (+Polly) 23.1.5
- **LLVM Commit**: `392dfff97d29b59d77e5cac6d4b6ef2585fe7117`
- **Target Triple**: `x86_64-unknown-linux-gnu`
- **Supported Targets**: `X86`, `AArch64`, `ARM`
- **Year**: 2026
