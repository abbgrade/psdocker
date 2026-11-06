task InstallBuildDependencies -Jobs {
    Install-Module platyPs -Scope CurrentUser -ErrorAction Stop -Verbose
}

task InstallTestDependencies -Jobs {
    Install-Module Pester -MinimumVersion '5.0.0'
}

task InstallReleaseDependencies -Jobs {
}
