
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://github.com/gopasspw/gopass-jsonapi/releases/download/v1.14.11/gopass-jsonapi-1.14.11-windows-amd64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url64bit      = $url64
  softwareName  = 'gopass-jsonapi*'
  checksum64    = '7375353e0a1cea65d49f906658824111aad65100e25d5b36082a96220d60366b'
  checksumType64= 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
