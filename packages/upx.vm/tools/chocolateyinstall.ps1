$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'upx'
$category = 'Utilities'

$zipUrl = 'https://github.com/upx/upx/releases/download/v4.1.0/upx-4.1.0-win64.zip'
$zipSha256 = '382cee168d6261a76c3b6a98b3ca2de44930bf5faa5f2dc2ced4fa3850fe8ff6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true
