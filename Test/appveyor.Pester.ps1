$PSVersion = $PSVersionTable.PSVersion.Major
$TestFile = "TestResultsPS$PSVersion.xml"
$ProjectRoot = $ENV:APPVEYOR_BUILD_FOLDER

Set-Location $ProjectRoot

Invoke-Pester -Path "$ProjectRoot\Test" -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile" -PassThru |
    Export-Clixml -Path "$ProjectRoot\PesterResults$PSVersion.xml"
