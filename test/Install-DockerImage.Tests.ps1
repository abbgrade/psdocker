#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Install-DockerImage' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath
    }
    Context 'UnitTests' -Tag UnitTest {
        It 'pulls the requested image and returns its image object' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {
                    param ( $ArgumentList, $Timeout, $JsonOutput )

                    if ( $JsonOutput ) {
                        [pscustomobject] @{
                            Repository = 'example/app'
                            Tag        = 'v1'
                            ID         = 'sha256:456'
                            CreatedAt  = 'now'
                            Size       = '2MB'
                        }
                    }
                }

                # Act
                $image = Install-Image -Repository 'example/app' -Tag 'v1' -ErrorAction Stop

                # Assert
                $image.ImageName | Should -Be 'example/app:v1'
                Should -Invoke Invoke-ClientCommand -Times 2 -Exactly
            }
        }

        It 'does not pull an image or query it with WhatIf' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {}
                Mock Get-Image {}

                # Act
                Install-Image -Repository 'example/app' -WhatIf

                # Assert
                Should -Invoke Invoke-ClientCommand -Times 0 -Exactly
                Should -Invoke Get-Image -Times 0 -Exactly
            }
        }
    }

    Context 'IntegrationTests' -Tag IntegrationTest {
        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
        }

        It 'works with named parameters' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository
            $tag = $global:TestConfig.Image.Tag

            # Act
            $image = Install-DockerImage -Repository $repository -Tag $tag -ErrorAction Stop

            # Assert
            $image.Repository | Should -Contain $repository
            $image.Tag | Should -Contain $tag
        }

        It 'works with pipeline parameters' {
            # Arrange
            $image = $global:TestConfig.Image

            # Act
            $install = { $image | Install-DockerImage -ErrorAction Stop }

            # Assert
            $install | Should -Not -Throw
        }

        It 'throws on invalid image' {
            # Arrange
            $repository = 'foobar'

            # Act
            $install = { Install-DockerImage -Repository $repository -WarningAction SilentlyContinue -ErrorAction Stop }

            # Assert
            $install | Should -Throw
        }
    }
}
