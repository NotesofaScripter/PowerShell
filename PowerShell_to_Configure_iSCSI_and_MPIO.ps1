$TargetPortalAddresses = @("192.168.10.6","192.168.10.7","192.168.10.8","192.168.10.9")
$LocaliSCSIAddress = "192.168.10.100"

$MSiSCSIServer = get-service -Name MSiSCSI
IF ($MSiSCSIServer.status -ne "Running"){Write-host "iSCSI Service has not been started" -ForegroundColor Yellow; break}

$MPIOFeature = Get-WindowsFeature -Name Multipath-IO
IF ($MPIOFeature.installed -ne "Installed"){Write-host "MPIO Feature has not been installed" -ForegroundColor Yellow; break}

Foreach ($TargetPortalAddress in $TargetPortalAddresses){
New-IscsiTargetPortal -TargetPortalAddress $TargetPortalAddress -TargetPortalPortNumber 3260 -InitiatorPortalAddress $LocaliSCSIAddress
}

New-MSDSMSupportedHW -VendorId MSFT2005 -ProductId iSCSIBusType_0x9


Foreach ($TargetPortalAddress in $TargetPortalAddresses){
Get-IscsiTarget | Connect-IscsiTarget -IsMultipathEnabled $true -TargetPortalAddress $TargetPortalAddress -InitiatorPortalAddress $LocaliSCSIAddress -IsPersistent $true
}

Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy FOO
