$RepositoryCompleter = {
    param (
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return Get-DockerImage | Select-Object -ExpandProperty Repository -Unique
}

Set-Variable -Name RepositoryCompleter -Value $RepositoryCompleter -Visibility Public -Scope Script

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

$NameCompleter = {
    param (
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return Get-DockerImage | Select-Object -ExpandProperty ImageName -Unique
}

Set-Variable -Name NameCompleter -Value $NameCompleter -Visibility Public -Scope Script
