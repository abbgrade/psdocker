$PSVersion = $PSVersionTable.PSVersion.Major
$ProjectRoot = $ENV:APPVEYOR_BUILD_FOLDER

Set-Location $ProjectRoot

foreach( $module in @( 'Client', 'Container' )) {
    Invoke-Pester -Path "$ProjectRoot\src\Modules\$module\Test" -OutputFormat NUnitXml -OutputFile "$ProjectRoot\TestResults.$module.PS$PSVersion.xml" -PassThru |
        Export-Clixml -Path "$ProjectRoot\PesterResults.$module.$PSVersion.xml"
}