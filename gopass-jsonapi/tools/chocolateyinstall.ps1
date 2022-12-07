﻿
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.0/gopass-jsonapi-1.15.0-windows-amd64.zip'
$packageParameters = Get-PackageParameters

if (!$packageParameters['BROWSERS']) { $packageParameters['BROWSERS'] = 'chrome' }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  softwareName   = 'gopass-jsonapi*'
  checksum64     = 'e4d4ffad006c51951a5f7c210c5e2cc6d014657ada0c62b3ad47a20f04c6f9e5'
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
