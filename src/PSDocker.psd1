@{
    RootModule = 'PSDocker.psm1'
    ModuleVersion = '1.6.0'
    GUID = '22cb8e1e-1c64-446b-960c-7c5e8529eb31'
    Author = 'Steffen Kampmann'
    Copyright = '(c) 2018 s.kampmann. Alle Rechte vorbehalten.'
    Description = 'Cmdlets that wraps the docker client and supports the interaction with containers.'
    FunctionsToExport = '*'
    CmdletsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport = '*'
    PrivateData = @{
        PSData = @{
            Prerelease = 'beta'
            Tags = @('Docker')
            LicenseUri = 'https://github.com/abbgrade/PSDocker/blob/master/LICENSE'
            ProjectUri = 'https://github.com/abbgrade/PSDocker'
        }
    }
    DefaultCommandPrefix = 'Docker'
}
