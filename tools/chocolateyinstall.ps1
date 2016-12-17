$ErrorActionPreference = 'Stop';

$packageName= 'McAfeeFramework'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $packageName
    url            = 'https://artifactory.-.com/artifactory/win-binaries/FramePkg.exe'
    checksum       = '4E1731F987FDA4B42E73EB9E03AB9AB944E4A72A29E4D3BB9D07B87BBE14648C'
    checksumtype   = 'sha256' 
    fileType       = 'exe'
    silentArgs     = "/install=agent /s"
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs