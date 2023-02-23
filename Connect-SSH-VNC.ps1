#powershell.exe

# Written by Aaron Wurthmann
#
# You the executor, runner, user accept all liability.
# This code comes with ABSOLUTELY NO WARRANTY.
# You may redistribute copies of the code under the terms of the GPL v3.
#
# --------------------------------------------------------------------------------------------
# Name: Connect-SSH-VNC.ps1
# Date: 2023.02.23 ver 1.6
# Description:
# Quick AND secure method to connect to a Mac from a Windows system using SSH tunneling
#
# Tested with: Microsoft Windows [Version 10.0.22621.1265] >  macOS Ventura 13.0.1
# --------------------------------------------------------------------------------------------


Param (
	[string]$RemoteUser = "awurthmann",
	[string]$RemoteHost = "10.1.33.7",
	[int]$RemotePort = "5900"
)


$OpenPorts=(Get-NetTCPConnection).LocalPort

[int]$LocalPort=0
While ($LocalPort -eq 0) {
	$RandomPort = Get-Random -Minimum 49152 -Maximum 65535
	If ($OpenPorts -notcontains $RandomPort) {
		$LocalPort=$RandomPort
	}
}

If (Test-Path $PSScriptRoot\settings.json) {
	$SettingsObject = Get-Content -Path $PSScriptRoot\settings.json | ConvertFrom-Json
	If ($SettingsObject.RemoteUser) {$RemoteUser = $SettingsObject.RemoteUser}
	If ($SettingsObject.RemoteHost) {$RemoteHost = $SettingsObject.RemoteHost}
	If ($SettingsObject.RemotePort) {$RemotePort = $SettingsObject.RemotePort}
}

## settings.json example
# {
	# "RemoteUser": "awurthmann",
	# "RemoteHost": "1.12.133.7"
# }


$SSHExpression = "ssh -L " + $LocalPort.ToString() +":"+ $RemoteHost +":"+ $RemotePort.ToString() + " $RemoteUser@$RemoteHost"
Write-Host $SSHExpression -ForegroundColor Blue -BackgroundColor Black
$VNCFilePath = "C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe"
$VNCHostAndPort = "localhost:" + $LocalPort.ToString()
$VNCExpression = $VNCFilePath +" "+$VNCHostAndPort
Write-Host $VNCExpression -ForegroundColor Green -BackgroundColor Black

Start-Process powershell.exe -argument "-noexit -nologo -noprofile -command $SSHExpression"

[int]$Tries=0
[bool]$KeepTrying=$True
[bool]$Connect=$True
While ($KeepTrying) {
	$Connection=Get-NetTCPConnection | Where {$_.LocalPort -eq $LocalPort}
	If ($Connection) {$KeepTrying = $False}
	Else {$Tries++}
	If ($Tries -ge 30) {
		$KeepTrying = $False
		$Connect = $False
	}
	Start-Sleep -Seconds 1
}

If (!($KeepTrying) -and $Connect) {
	Start-Process -FilePath $VNCFilePath -ArgumentList $VNCHostAndPort
}
Else {
	""
	Write-Host "ERROR: Port $LocalPort is not open or was not tunneled to $RemoteHost" -ForegroundColor Red -BackgroundColor Black
	""
}
