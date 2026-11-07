#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Get-DockerContainer' -Tag IntegrationTest {

    BeforeAll {
        . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
    }
    Context 'there are some containers' {
        BeforeAll {
            $global:TestConfig.Image | Install-DockerImage -ErrorAction Stop

            $script:ContainerNames = New-Object System.Collections.ArrayList
            1..2 | ForEach-Object {
                $name = "psdocker-test-$([guid]::NewGuid().ToString('N'))"
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
            # Arrange
            $namePrefix = 'psdocker-test-'

            # Act
            $matchingContainers = @( Get-DockerContainer -Name $namePrefix )

            # Assert
            $matchingContainers.Count | Should -Be 2
            foreach ( $name in $script:ContainerNames ) {
                $matchingContainers.Name | Should -Contain $name
            }
        }
    }
}
