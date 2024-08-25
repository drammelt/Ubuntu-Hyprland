#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# wallust - pywal colors replacement #

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

# Source external functions, adjust path as necessary
source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_wallust.log"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG")"

# Install up-to-date Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >> "$LOG" 2>&1
source "$HOME/.cargo/env"

# Remove any existing Wallust binary
if [[ -f "/usr/local/bin/wallust" ]]; then
    echo "Removing existing Wallust binary..."
    sudo rm "/usr/local/bin/wallust" >> "$LOG" 2>&1
fi

# Install Wallust using Cargo
echo "Installing Wallust using Cargo..."
if cargo install wallust >> "$LOG" 2>&1; then
    echo "Wallust installed successfully."

    # Move the newly compiled binary to /usr/local/bin
    echo "Moving Wallust binary to /usr/local/bin..."
    sudo mv "$HOME/.cargo/bin/wallust" /usr/local/bin >> "$LOG" 2>&1
else
    echo "Error: Wallust installation failed. Check the log file $LOG for details."
    exit 1
fi

clear
