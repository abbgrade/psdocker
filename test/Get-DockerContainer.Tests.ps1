#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Get-DockerContainer' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }

    Context 'IntegrationTests' -Tag IntegrationTest {
        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
            $global:TestConfig.Image | Install-DockerImage -ErrorAction Stop

            $script:NamePrefix = "psdocker-test-$([guid]::NewGuid().ToString('N'))-"
            $script:ContainerNames = New-Object System.Collections.ArrayList
            1..2 | ForEach-Object {
                $name = "$script:NamePrefix$_"
                New-DockerContainer -Image $global:TestConfig.Image.Name -Name $name -ErrorAction Stop | Out-Null
                $script:ContainerNames.Add($name) | Out-Null
            }
        }

        AfterAll {
            foreach ( $name in $script:ContainerNames ) {
                Remove-DockerContainer -Name $name -Force -ErrorAction Continue
            }
        }

        It 'returns the containers matching a unique name prefix' {
            # Act
            $matchingContainers = @( Get-DockerContainer -Name $script:NamePrefix -ErrorAction Stop )

            # Assert
            $matchingContainers.Count | Should -Be 2
            foreach ( $name in $script:ContainerNames ) {
                $matchingContainers.Name | Should -Contain $name
            }
        }
    }
}
