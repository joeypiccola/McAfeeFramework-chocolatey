# Put the system in unmanaged mode. If the system has no other mcafee components, then this will also uninstall the agent.
# If this does remove the agent, then note that when chocolateyuninstall.ps1 runs it will simply finish and not actually uninstall anything.
Write-Host "Putting system in unmanaged mode."
Write-Host "If no McAfee Framework sub-components are installed this will also uninstall the agent."
Start-Process -FilePath "C:\Program Files (x86)\McAfee\Common Framework\frminst.exe" -ArgumentList "/remove=agent /silent" -WorkingDirectory "C:\Program Files (x86)\McAfee\Common Framework" -Wait -Verbose