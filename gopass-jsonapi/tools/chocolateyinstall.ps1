
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.14.11/gopass-jsonapi-1.14.11-windows-amd64.zip'
$packageParameters = Get-PackageParameters

if (!$packageParameters['BROWSERS']) { $packageParameters['BROWSERS'] = 'chrome' }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  softwareName   = 'gopass-jsonapi*'
  checksum64     = '7375353e0a1cea65d49f906658824111aad65100e25d5b36082a96220d60366b'
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

$gopassJsonapiPath = @{
  path      = $toolsDir
  childPath = 'gopass-jsonapi.exe'
}

$gopassProgramdataFolder = @{
  path      = $env:ProgramData
  childPath = 'gopass'
}

$configArgs = @{
  filePath     = "cmd.exe"
  argumentList = @(
    '/c'
    'echo'
    'Y'
    '|'
    "`"$(Join-Path @gopassJsonapiPath)`""
    'configure'
    '--browser'
    "`"$($packageParameters['BROWSERS'])`""
    '--path'
    "`"$(Join-Path @gopassProgramdataFolder)`""
    "--global"
  )
}

Start-Process @configArgs
