$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  ###################################
  # Install of drivers dependencies #
  ###################################
  $zipCliUrl = 'https://github.com/ArsenalRecon/Arsenal-Image-Mounter/raw/master/Command%20line%20applications/aim_ll.zip'
  $zipCliSha256 = '21c32aed320eca532969590b67dc8151bddd6aebe9699abd09cc3e026fd01a29'
  $tempCliDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "aim_ll"
  $toolCli = "aim_ll.exe"

  $zipDriverUrl = 'https://github.com/ArsenalRecon/Arsenal-Image-Mounter/raw/63801fc2b51f899244e43f1bf5275d2ac92a2477/DriverSetup/DriverFiles.zip'
  $zipDriverSha256 = 'c5de8e5d5a2c0231baf2cdb74fb0b0f4047658c69105bcab28990734b3979ee3'
  $tempDriverDownloadDir = Join-Path ${Env:TEMP} "temp_$([guid]::NewGuid())"

  $packageArgs = @{
      packageName    = ${Env:ChocolateyPackageName}
      unzipLocation  = $tempCliDownloadDir
      url            = $zipCliUrl
      checksum       = $zipCliSha256
      checksumType   = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $tempCliDownloadDir

  $packageArgs = @{
      packageName    = ${Env:ChocolateyPackageName}
      unzipLocation  = $tempDriverDownloadDir
      url            = $zipDriverUrl
      checksum       = $zipDriverSha256
      checksumType   = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs | Out-Null
  VM-Assert-Path $tempDriverDownloadDir

  if (Get-OSArchitectureWidth -Compare 64) {
      $toolCliDir = Join-Path $tempCliDownloadDir "x64"
  }
  else {
      $toolCliDir = Join-Path $tempCliDownloadDir "x32"
  }
  $toolCliPath = Join-Path $toolCliDir $toolCli
  # Install drivers messages displayed in stderr even on successful install, bypass by creating an external process
  Start-Process -FilePath $toolCliPath -ArgumentList "--install $tempDriverDownloadDir" -Wait

  ######################
  # Install of package #
  ######################
  $toolName = 'ArsenalImageMounter'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $shimPath = "\bin\${toolName}.exe"

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ChocolateyInstall} $shimPath -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
