#!/bin/bash

set -euxo pipefail

initial_setup_wsl() {
    if [ ! -e ~/dotfiles/config/initial_setup_wsl ]; then
        powershell.exe Set-ExecutionPolicy Bypass -Scope CurrentUser

        SCRIPT_DIR=/mnt/c/users/wheybags
        SCRIPT_DIR_WIN="C:\\users\\wheybags"
        
        # install chocolatey
        echo "Start-Process PowerShell -verb runas -Wait -ArgumentList '-File','$SCRIPT_DIR_WIN\\choco_boot_2.ps1'" > "$SCRIPT_DIR/choco_boot_1.ps1"
        echo "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" > "$SCRIPT_DIR/choco_boot_2.ps1"
        powershell.exe "$SCRIPT_DIR_WIN\\choco_boot_1.ps1"
        rm "$SCRIPT_DIR/choco_boot_1.ps1"
        rm "$SCRIPT_DIR/choco_boot_2.ps1"

        # enable ssh agent
        echo "Start-Process PowerShell -verb runas -Wait -ArgumentList '-File','$SCRIPT_DIR_WIN\\choco_boot_2.ps1'" > "$SCRIPT_DIR/choco_boot_1.ps1"
        echo "Start-Service ssh-agent" > "$SCRIPT_DIR/choco_boot_2.ps1"
        echo "Set-Service -StartupType Automatic ssh-agent" >> "$SCRIPT_DIR/choco_boot_2.ps1"
        powershell.exe "$SCRIPT_DIR_WIN\\choco_boot_1.ps1"
        rm "$SCRIPT_DIR/choco_boot_1.ps1"
        rm "$SCRIPT_DIR/choco_boot_2.ps1"

        ~/dotfiles/bin/choco feature enable -n allowGlobalConfirmation

        touch ~/dotfiles/config/initial_setup_wsl
    fi
}

initial_setup_wsl

~/dotfiles/bin/choco install procexp firefox notepadplusplus keepassxc everything seafile-client vlc 7zip tiled obs dependencies meld winmerge git
