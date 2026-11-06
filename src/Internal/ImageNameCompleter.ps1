$ImageNameCompleter = {
    param (
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return Get-DockerImage | Select-Object -ExpandProperty ImageName -Unique
}

Set-Variable -Name ImageNameCompleter -Value $ImageNameCompleter -Visibility Public -Scope Script
