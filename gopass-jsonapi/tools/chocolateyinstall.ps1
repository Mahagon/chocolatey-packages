
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.4/gopass-jsonapi-1.15.4-windows-amd64.zip'
$packageParameters = Get-PackageParameters

if (!$packageParameters['Browser']) { $packageParameters['Browser'] = 'chrome' }
if (!$packageParameters['Configure']) { $packageParameters['Configure'] = 'false' }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  softwareName   = 'gopass-jsonapi*'
  checksum64     = '0c36991721b04092b777ee3c2e181f11219a487d781971c09d0f9dc0b5b96a50'
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
  exeToRun       = $env:ComSpec
  statements     = @(
    '/c'
    'echo'
    'Y'
    '|'
    "`"$(Join-Path @gopassJsonapiPath)`""
    'configure'
    '--browser'
    "`"$($packageParameters['Browser'])`""
    '--path'
    "`"$(Join-Path @gopassProgramdataFolder)`""
    "--global"
  )
}

if ($packageParameters['Configure'] -ieq 'true') {
  Start-ChocolateyProcessAsAdmin @configArgs
}
