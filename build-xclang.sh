#!/usr/bin/env bash
# ==============================================================================
# XClang (+Polly) LLVM Toolchain Builder
# Compatible with Android GKI Linux Kernel (5.10, 5.15, 6.1+) and NDK
# ==============================================================================

set -euo pipefail

LLVM_TAG="${1:-llvmorg-23.1.5}"
WORK_DIR="${2:-/tmp/xclang-build}"
INSTALL_DIR="${WORK_DIR}/install"
BUILD_DIR="${WORK_DIR}/build"
SRC_DIR="${WORK_DIR}/llvm-project"
JOBS="$(nproc)"

echo "=== [1/6] Cloning LLVM Project (${LLVM_TAG}) ==="
mkdir -p "${WORK_DIR}"
if [ ! -d "${SRC_DIR}" ]; then
  git clone --depth 1 --branch "${LLVM_TAG}" https://github.com/llvm/llvm-project.git "${SRC_DIR}"
else
  echo "Source directory already exists at ${SRC_DIR}, updating..."
  git -C "${SRC_DIR}" fetch --depth 1 origin tag "${LLVM_TAG}"
  git -C "${SRC_DIR}" checkout "${LLVM_TAG}"
fi

LLVM_COMMIT="$(git -C "${SRC_DIR}" rev-parse HEAD)"
echo "LLVM Commit: ${LLVM_COMMIT}"

echo "=== [2/6] Configuring CMake ==="
mkdir -p "${BUILD_DIR}"
cmake -G Ninja \
  -S "${SRC_DIR}/llvm" \
  -B "${BUILD_DIR}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DLLVM_USE_LINKER=lld \
  -DLLVM_ENABLE_PROJECTS="clang;lld;polly" \
  -DLLVM_TARGETS_TO_BUILD="X86;AArch64;ARM" \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DCLANG_VENDOR="XClang (+Polly)" \
  -DCLANG_REPOSITORY_STRING="https://github.com/llvm/llvm-project.git" \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_BENCHMARKS=OFF \
  -DLLVM_INCLUDE_DOCS=OFF \
  -DLLVM_ENABLE_LIBXML2=ON \
  -DLLVM_ENABLE_ZLIB=ON \
  -DLLVM_ENABLE_ZSTD=ON \
  -DLLVM_ENABLE_PIC=ON

echo "=== [3/6] Building and Installing (${JOBS} threads) ==="
ninja -C "${BUILD_DIR}" install -j"${JOBS}"

echo "=== [4/6] Creating Metadata and Licenses ==="
echo "based on XClang LLVM custom build" > "${INSTALL_DIR}/AndroidVersion.txt"
echo "platform/prebuilts/clang/host/linux-x86 ${LLVM_COMMIT}" > "${INSTALL_DIR}/repo.prop"
touch "${INSTALL_DIR}/MODULE_LICENSE_BSD_LIKE"
touch "${INSTALL_DIR}/MODULE_LICENSE_MIT"
cp "${SRC_DIR}/llvm/LICENSE.TXT" "${INSTALL_DIR}/NOTICE"

echo "=== [5/6] Verifying Compiler Binary ==="
"${INSTALL_DIR}/bin/clang" --version

echo "=== [6/6] Packaging Tarball ==="
CLANG_VER="$("${INSTALL_DIR}/bin/clang" --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
TARBALL_NAME="XClang-${CLANG_VER}-Polly.tar.gz"
tar --use-compress-program=pigz -cf "${WORK_DIR}/${TARBALL_NAME}" -C "${INSTALL_DIR}" .
echo "Generated release archive: ${WORK_DIR}/${TARBALL_NAME}"
sha256sum "${WORK_DIR}/${TARBALL_NAME}"

echo "=== Build Complete! ==="
