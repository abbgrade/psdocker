#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

Describe 'Get-DockerImage' {

    BeforeAll {
        . $PSScriptRoot\Helper\UnitTestSetup.ps1
        Import-Module $ModuleManifestPath -Force
    }
    Context 'mapping command output' -Tag UnitTest {
        It 'maps image fields and translates an untagged image tag to null' {
            # Arrange
            InModuleScope psdocker {
                Mock Invoke-ClientCommand {
                    param ( $ArgumentList, $Timeout, $JsonOutput )

                    [pscustomobject] @{
                        Repository = 'example/app'
                        Tag        = '<none>'
                        ID         = 'sha256:123'
                        CreatedAt  = 'now'
                        Size       = '1MB'
                    }
                }

                # Act
                $image = Get-Image -Repository 'example/app' -ErrorAction Stop

                # Assert
                $image.Repository | Should -Be 'example/app'
                $image.Tag | Should -BeNullOrEmpty
                $image.Id | Should -Be 'sha256:123'
                $image.ImageName | Should -Be 'example/app'
                Should -Invoke Invoke-ClientCommand -Times 1 -Exactly -ParameterFilter {
                    $ArgumentList[0] -eq 'image ls' -and $JsonOutput
                }
            }
        }
    }

    Context 'one image of a repository is installed' -Tag IntegrationTest {
        BeforeAll {
            . $PSScriptRoot\Helper\IntegrationTestSetup.ps1
            $image = $global:TestConfig.Image
            Install-DockerImage -Repository $image.Repository -Tag $image.Tag -ErrorAction Stop
        }

        It 'returns a list of images' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository

            # Act
            $images = @( Get-DockerImage -Repository $repository -ErrorAction Stop )

            # Assert
            $images.Count | Should -BeGreaterThan 0
            $images.Repository | Should -Not -Contain $null
        }

        It 'returns a specific image' {
            # Arrange
            $repository = $global:TestConfig.Image.Repository
            $tag = $global:TestConfig.Image.Tag

            # Act
            $image = Get-DockerImage -Repository $repository -Tag $tag -ErrorAction Stop

            # Assert
            $image.Repository | Should -Be $repository
            $image.Tag | Should -Be $tag
            $image.Id | Should -Not -BeNullOrEmpty
        }
    }
}
