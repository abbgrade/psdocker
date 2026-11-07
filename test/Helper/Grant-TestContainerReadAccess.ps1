<#
.SYNOPSIS
Grants test containers read access to a host directory.

.DESCRIPTION
Adds an inheritable ReadAndExecute allow rule for Everyone to the specified
directory so a container can read the directory and its files.

.NOTES
This changes the directory's access control list. Use only with a test
directory; the permission is granted to Everyone.
#>
function Grant-TestContainerReadAccess {
    param (
        # Host directory to make readable by test containers.
        [Parameter(Mandatory)][string] $Path
    )

    $acl = Get-Acl $Path
    $worldSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-1-0')
    $readRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
        $worldSid,
        [System.Security.AccessControl.FileSystemRights]::ReadAndExecute,
        [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
            [System.Security.AccessControl.InheritanceFlags]::ObjectInherit,
        [System.Security.AccessControl.PropagationFlags]::None,
        [System.Security.AccessControl.AccessControlType]::Allow
    )
    $acl.SetAccessRule($readRule)
    Set-Acl -Path $Path -AclObject $acl
}
