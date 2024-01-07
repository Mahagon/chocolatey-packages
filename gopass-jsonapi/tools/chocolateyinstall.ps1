
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.11/gopass-jsonapi-1.15.11-windows-amd64.zip'
$packageParameters = Get-PackageParameters

if (!$packageParameters['Browser']) { $packageParameters['Browser'] = 'chrome' }
if (!$packageParameters['Configure']) { $packageParameters['Configure'] = 'false' }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  softwareName   = 'gopass-jsonapi*'
  checksum64     = 'aedb0c46343bf11817b6b54fe273494264ea26e0dc952371e6147eaa1e531942'
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
