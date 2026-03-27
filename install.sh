#!/bin/bash
set -euo pipefail

REPO="dirp-dev/dirp"
BINARY_NAME="dirp"
INSTALL_DIR="${DIRP_INSTALL_DIR:-$HOME/.local/bin}"

# Detect OS
case "$(uname -s)" in
    Linux*)  OS="unknown-linux-gnu" ;;
    Darwin*) OS="apple-darwin" ;;
    *)       echo "Error: unsupported OS '$(uname -s)'" >&2; exit 1 ;;
esac

# Detect architecture
case "$(uname -m)" in
    x86_64|amd64)  ARCH="x86_64" ;;
    arm64|aarch64) ARCH="aarch64" ;;
    *)             echo "Error: unsupported architecture '$(uname -m)'" >&2; exit 1 ;;
esac

TARGET="${ARCH}-${OS}"

# Get latest release tag
echo "Fetching latest release..."
LATEST=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$LATEST" ]; then
    echo "Error: could not determine latest release" >&2
    exit 1
fi
echo "Latest release: ${LATEST}"

# Download binary
ASSET_NAME="${BINARY_NAME}-${TARGET}"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST}/${ASSET_NAME}"

echo "Downloading ${ASSET_NAME}..."
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

if ! curl -fsSL -o "$TMPFILE" "$DOWNLOAD_URL"; then
    echo "Error: failed to download ${DOWNLOAD_URL}" >&2
    echo "Check that a release exists for target '${TARGET}'" >&2
    exit 1
fi

chmod +x "$TMPFILE"

# Install
mkdir -p "$INSTALL_DIR"
mv "$TMPFILE" "${INSTALL_DIR}/${BINARY_NAME}"

echo "dirp ${LATEST} installed to ${INSTALL_DIR}/${BINARY_NAME}"
