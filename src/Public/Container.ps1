class Container {
    [string] $Id
    [string[]] $Names
    [string] $Image
    [string] $Command
    [string] $LocalVolumes
    [string] $Labels
    [string] $Mounts
    [string] $Networks
    [string] $Ports
    [string] $CreatedAt
    [string] $RunningFor
    [string] $Status
    [string] $Size

    Container() {
        $this | Add-Member -Name Name -MemberType ScriptProperty -Value {
            return $this.Names[0]
        }
    }
}
