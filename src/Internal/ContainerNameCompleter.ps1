$ContainerNameCompleter = {
    param (
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    return Get-DockerContainer | Select-Object -ExpandProperty Name -Unique
}

Set-Variable -Name ContainerNameCompleter -Value $ContainerNameCompleter -Visibility Public -Scope Script
