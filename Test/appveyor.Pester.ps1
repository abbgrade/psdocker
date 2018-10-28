$PSVersion = $PSVersionTable.PSVersion.Major
$ProjectRoot = $ENV:APPVEYOR_BUILD_FOLDER

Set-Location $ProjectRoot

Invoke-Pester -Path "$ProjectRoot\src\PSDocker\Test" -OutputFormat NUnitXml -OutputFile "$ProjectRoot\TestResults.PSDocker.PS$PSVersion.xml" -PassThru |
    Export-Clixml -Path "$ProjectRoot\PesterResults.PSDocker.$PSVersion.xml"