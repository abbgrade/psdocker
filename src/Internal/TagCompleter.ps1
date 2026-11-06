$TagCompleter = {
    param (
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    $possibleValues = Get-DockerImage

    if ($fakeBoundParameters.ContainsKey('Repository')) {
        $Repository = $fakeBoundParameters.Repository

        $possibleValues | Where-Object -FilterScript {
            $_.Repository -eq $Repository
        } | Where-Object -FilterScript {
            $_.Tag
        } | Select-Object -ExpandProperty Tag
    }
    else {
        $possibleValues.Values | ForEach-Object { $_ }
    }
}

Set-Variable -Name TagCompleter -Value $TagCompleter -Visibility Public -Scope Script
