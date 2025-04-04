$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'WinDbg'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

    # Download the installer
    $packageArgs        = @{
        packageName     = $env:ChocolateyPackageName
        file            = Join-Path ${Env:TEMP} "$toolName.appinstaller"
        url             = 'https://aka.ms/windbg/download'
    }
    $filePath = Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $filePath
    VM-Assert-Signature $filePath

    Add-AppxPackage -AppInstallerFile $packageArgs.file

    $toolPackage = Get-AppxPackage -Name "Microsoft.$toolName"
    $iconLocation = Join-Path $toolPackage.InstallLocation "DbgX.Shell.exe" -Resolve
    $executablePath = "shell:AppsFolder\$($toolPackage.PackageFamilyName)!$($toolPackage.Name)"

    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -iconLocation $iconLocation -RunAsAdmin
} catch {
    VM-Write-Log-Exception $_
}
