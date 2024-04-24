$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $category = 'Utilities'
  $toolName = 'CyberChef'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v10.18.3/CyberChef_v10.18.3.zip'
    checksum      = 'fef9875c6c389539a8ed76ad765496d80061e9350b257b2b1aeec0b96090e40a'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe" -Resolve
  $htmlPath = Join-Path $toolDir "CyberChef_v10.18.3.html" -Resolve
  $arguments = "start chrome $htmlPath && exit"
  $executableArgs = "/C $arguments"
  $iconLocation = "%ProgramFiles%\Google\Chrome\Application\chrome.exe"

  Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $toolDir -WindowStyle 7 -IconLocation $iconLocation

  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
