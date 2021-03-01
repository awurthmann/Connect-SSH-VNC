# Connect-SSH-VNC
Establish SSH connection from Microsoft Windows system then tunnels RealVNC session through SSH connection to host, example to macOS host.

## Legal
You the executor, runner, user accept all liability.
This code comes with ABSOLUTELY NO WARRANTY.
You may redistribute copies of the code under the terms of the GPL v3.

## Warning
- The intent of this script is to encrypt the VNC session when connecting from a Windows system to an Apple macOS system.
  - Connecting from Windows to macOS is not encrypted as of March 1st, 2021.
  - This script establishes an SSH tunnel then VNCs through the tunnel.
  - Connecting from macOS to macOS is encrypted.
- In order to allow a Windows system to connect to a macOS system the macOS system has to allow standard VNC. It should be noted that allowing standard VNC/Screen Sharing does not fit security best practices.
  - TL;DR I have my reasons for doing things this way; you the executor, runner, user, accept all liability and should likely have your own reasons.

## Prerequisites
- Install RealVNC
- Complete macOS Setup

## macOS Setup:
Open System Prefferences
  Navigate to "Screen Sharing"
  - Click [Computer Settings...]
    - Uncheck "Anyone may request permission to control screen"
    - Check "VNC viewers may control screen with password"
      - Enter complex 8 character password.
    - Click [OK]
  - Check "Only these users:"
    - Click [+] to "Select" users
  Navigate to "Remote Login"
    - Check "Only these users:"
      - Click [+] to "Select" users

## Windows Instructions:
  - Download Connect-SSH-VNC.ps1
  - Open PowerShell.
  - Navigate to file download location.
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\Connect-SSH-VNC.ps1 -RemoteUser <remote username> -RemoteHost <remote hostname>
```
  - A separate PowerShell window will be opened.
  - Enter the remote user's password to SSH to this host.
  - A RealVNC Window will open and indicates that the session to localhost::<port number> is not encrypted.
    Techincally that is true BUT what VNC doesn't know is that you are tunneling <port number> through the SSH tunnel
  - Click [Continue]
  - Enter the "Screen Sharing" password
  - You may, again, be warned that the session is not encrypted.
  - Log into the remote system as needed

## Alternative Windows Instructions:
  - Download Connect-SSH-VNC.ps1
  - Edit Connect-SSH-VNC.ps1 with your ownn default settings.
  - Open PowerShell.
  - Navigate to file download location.
```powershell
.\Connect-SSH-VNC.ps1
```

