#powershell.exe

# Written by Aaron Wurthmann
#
# You the executor, runner, user accept all liability.
# This code comes with ABSOLUTELY NO WARRANTY.
# You may redistribute copies of the code under the terms of the GPL v3.
#
# --------------------------------------------------------------------------------------------
# Name: Connect-SSH-VNC.ps1
# Date: 2021.02.19 ver 1
# Description:
# Quick AND secure method to connect to a Mac from a Windows system using SSH tunneling
#
# Tested with: Microsoft Windows [Version 10.0.19042.804] >  macOS Catalina 10.15.7 (19H2)
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

$SSHExpression = "ssh -L " + $LocalPort.ToString() +":"+ $RemoteHost +":"+ $RemotePort.ToString() + " $RemoteUser@$RemoteHost"
Write-Host $SSHExpression -ForegroundColor Blue -BackgroundColor Black
$VNCFilePath = "C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe"
$VNCHostAndPort = "localhost:" + $LocalPort.ToString()
$VNCExpression = $VNCFilePath +" "+$VNCHostAndPort
Write-Host $VNCExpression -ForegroundColor Green -BackgroundColor Black

Start-Process powershell.exe -argument "-noexit -nologo -noprofile -command $SSHExpression"

[int]$Tries=0
[bool]$KeepTrying=$True
While ($KeepTrying) {
	$Connection=Get-NetTCPConnection | Where {$_.LocalPort -eq $LocalPort}
	If ($Connection) {$KeepTrying = $False}
	$Tries++
	If ($Tries -ge 30) {$KeepTrying = $False}
	Start-Sleep -Seconds 1
}

If (!($KeepTrying)) {
	Start-Process -FilePath $VNCFilePath -ArgumentList $VNCHostAndPort
}
