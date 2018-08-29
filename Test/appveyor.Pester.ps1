$PSVersion = $PSVersionTable.PSVersion.Major
$TestFile = "TestResultsPS$PSVersion.xml"
$ProjectRoot = $ENV:APPVEYOR_BUILD_FOLDER

Set-Location $ProjectRoot

Invoke-Pester -Path "$ProjectRoot\src\Modules\Client\Test" -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile" -PassThru |
    Export-Clixml -Path "$ProjectRoot\PesterResults$PSVersion.xml"

Invoke-Pester -Path "$ProjectRoot\src\Modules\Container\Test" -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile" -PassThru |
    Export-Clixml -Path "$ProjectRoot\PesterResults$PSVersion.xml"
