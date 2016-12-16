# The following is a heavily modified version of chocolateyuninstall.ps1.
# This was built to accommodate uninstalling the entire McAfee Framework and not just the agent. 

$ErrorActionPreference = 'Stop'
$packageName = 'McAfeeFramework'
$validExitCodes = @(0, 3010, 1605, 1614, 1641)

# An array of components in the exact order they should be uninstalled, starting with the agent and ending with the siem collector.
# The components listed are the names found in their uninstall DisplayName registry key.
$components = @('McAfee Agent|exe','McAfee VirusScan Enterprise|msi','McAfee SIEM Collector|msi')

$uninstalled = $false
foreach ($Component in $Components)
{   
    $componentDisplayName = $component.split('|')[0]
    $componentInstallType = $component.split('|')[1]
    $componentFullName = "$packageName\$componentDisplayName"

    if ($componentDisplayName -eq 'McAfee SIEM Collector')
    {
        # This is no joke, sleeping anything less than 60 seconds will fail due to file locks
        Write-Host "Sleeping 5min for things to settle before attempting to remove $componentFullName"
        sleep -Seconds 300
    }

    [array]$key = Get-UninstallRegistryKey -SoftwareName $componentDisplayName
    if ($key.count -eq 1)
    {
        $key | % {
            if ($componentInstallType -eq 'exe')
            {
                $file       = "$($_.InstallLocation)frminst.exe"
                $silentArgs = '/FORCEUNINSTALL /SILENT'
            }
            if ($componentInstallType -eq 'msi')
            {
                $file       = ''
                $silentArgs = "$($_.PSChildName) /qn /norestart /l*v c:\uninstall.log"
            }
            write-host "Attempting uninstall of $componentFullName"
            Uninstall-ChocolateyPackage -PackageName $componentFullName -FileType $componentInstallType -SilentArgs "$silentArgs"  -ValidExitCodes $validExitCodes -File "$file"
        }
    }
    elseif ($key.Count -eq 0)
    {
        Write-Warning "$componentFullName has either already been uninstalled or does not exist."
    }
    elseif ($key.Count -gt 1) 
    {
        Write-Warning "$key.Count matches found!"
        Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
        Write-Warning "Please alert package maintainer the following keys were matched:"
        $key | % {Write-Warning "- $_.DisplayName"}
    }
}