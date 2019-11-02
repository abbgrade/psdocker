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
