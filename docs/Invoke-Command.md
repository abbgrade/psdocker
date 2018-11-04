---
external help file: PSDocker-help.xml
Module Name: PSDocker
online version: http://go.microsoft.com/fwlink/?LinkId=821493
schema: 2.0.0
---

# Invoke-Command

## SYNOPSIS
Runs commands on local and remote computers.

## SYNTAX

```
Invoke-Command [-Name] <String> [-Command] <String> [-ArgumentList <String[]>] [[-Timeout] <Int32>]
 [-StringOutput] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-Command cmdlet runs commands on a local or remote computer and returns all output from the commands, including errors.
By using a single Invoke-Command command, you can run commands on multiple computers.

To run a single command on a remote computer, use the ComputerName parameter.
To run a series of related commands that share data, use the New-PSSession cmdlet to create a PSSession (a persistent connection) on the remote computer, and then use the Session parameter of Invoke-Command to run the command in the PSSession.
To run a command in a disconnected session, use the InDisconnectedSession parameter.
To run a command in a background job, use the AsJob parameter.

You can also use Invoke-Command on a local computer to evaluate or run a string in a script block as a command.
Windows PowerShell converts the script block to a command and runs the command immediately in the current scope, instead of just echoing the string at the command line.

To start an interactive session with a remote computer, use the Enter-PSSession cmdlet.
To establish a persistent connection to a remote computer, use the New-PSSession cmdlet.

Before using Invoke-Command to run commands on a remote computer, read about_Remote (http://go.microsoft.com/fwlink/?LinkID=135182).

## EXAMPLES

### Example 1: Run a script on a server
```
PS C:\>Invoke-Command -FilePath c:\scripts\test.ps1 -ComputerName Server01
```

This command runs the Test.ps1 script on the Server01 computer.

The command uses the FilePath parameter to specify a script that is located on the local computer.
The script runs on the remote computer and the results are returned to the local computer.

### Example 2: Run a command on a remote server
```
PS C:\>Invoke-Command -ComputerName server01 -Credential domain01\user01 -ScriptBlock {Get-Culture}
```

This command runs a Get-Culture command on the Server01 remote computer.

It uses the ComputerName parameter to specify the computer name and the Credential parameter to run the command in the security context of Domain01\User01, a user who has permission to run commands.
It uses the ScriptBlock parameter to specify the command to be run on the remote computer.

In response, Windows PowerShell displays a dialog box that requests the password and an authentication method for the User01 account.
It then runs the command on the Server01 computer and returns the result.

### Example 3: Run a command in a persistent connection
```
PS C:\>$s = New-PSSession -ComputerName Server02 -Credential Domain01\User01
PS C:\> Invoke-Command -Session $s -ScriptBlock {Get-Culture}
```

This example runs the same Get-Culture command in a session, which is a persistent connection, on the remote computer named Server02.
Typically, you create a session only when you run a series of commands on the remote computer.

The first command uses the New-PSSession cmdlet to create a session on the Server02 remote computer.
Then, it saves the session in the $s variable.

The second command uses the Invoke-Command cmdlet to run the Get-Culture command on Server02.
It uses the Session parameter to specify the session saved in the $s variable.

In response, Windows PowerShell runs the command in the session on the Server02 computer.

### Example 4: Use a session to run a series of commands that share data
```
PS C:\>Invoke-Command -ComputerName Server02 -ScriptBlock {$p = Get-Process PowerShell}
PS C:\> Invoke-Command -ComputerName Server02 -ScriptBlock {$p.VirtualMemorySize}
PS C:\>
PS C:\> $s = New-PSSession -ComputerName Server02
PS C:\> Invoke-Command -Session $s -ScriptBlock {$p = Get-Process PowerShell}
PS C:\> Invoke-Command -Session $s -ScriptBlock {$p.VirtualMemorySize}
17930240
```

This example compares the effects of using ComputerName and Session parameters of Invoke-Command .
It shows how to use a session to run a series of commands that share the same data.

The first two commands use the ComputerName parameter of Invoke-Command to run commands on the Server02 remote computer.
The first command uses the Get-Process cmdlet to get the PowerShell process on the remote computer and to save it in the $p variable.
The second command gets the value of the VirtualMemorySize property of the PowerShell process.

The first command succeeds.
But the second command fails, because when you use the ComputerName parameter, Windows PowerShell creates a connection just to run the command.
Then, it closes the connection when the command is completed.
The $p variable was created in one connection, but it does not exist in the connection created for the second command.

The problem is solved by creating a session, which is a persistent connection, on the remote computer and by running both of the related commands in the same session.

The third command uses the New-PSSession cmdlet to create a session on the computer named Server02.
Then it saves the session in the $s variable.
The fourth and fifth commands repeat the series of commands that were used in the first set, but in this case, the Invoke-Command command uses the Session parameter to run both of the commands in the same session.

In this case, because both commands run in the same session, the commands succeed, and the $p value remains active in the $s session for later use.

### Example 5: Enter a command stored in a local variable
```
PS C:\>$command = { Get-EventLog -log "Windows PowerShell" | where {$_.Message -like "*certificate*"} }
PS C:\> Invoke-Command -ComputerName S1, S2 -ScriptBlock $command
```

This example shows how to enter a command that is stored in a local variable.

When the whole command is saved in a local variable, you can specify the variable as the value of the ScriptBlock parameter.
You do not have to use the param keyword or the ArgumentList variable to submit the value of the local variable.

The first command saves a Get-EventLog command in the $command variable.
The command is formatted as a script block.

The second command uses Invoke-Command to run the command in $command on the S1 and S2 remote computers.

### Example 6: Run a single command on several computers
```
PS C:\>Invoke-Command -ComputerName Server01, Server02, TST-0143, localhost -ConfigurationName MySession.PowerShell -ScriptBlock {Get-EventLog "Windows PowerShell"}
```

This example demonstrates how to use Invoke-Command to run a single command on multiple computers.

The command uses the ComputerName parameter to specify the computers.
The computer names are presented in a comma-separated list.
The list of computers includes the localhost value, which represents the local computer.

The command uses the ConfigurationName parameter to specify an alternate session configuration for Windows PowerShell and the ScriptBlock parameter to specify the command.

In this example, the command in the script block gets the events in the Windows PowerShell event log on each remote computer.

### Example 7: Get the version of the host program on multiple computers
```
PS C:\>$version = Invoke-Command -ComputerName (Get-Content Machines.txt) -ScriptBlock {(Get-Host).Version}
```

This command gets the version of the Windows PowerShell host program running on 200 remote computers.

Because only one command is run, you do not have to create persistent connections to each of the computers.
Instead, the command uses the ComputerName parameter to indicate the computers.

The command uses the Invoke-Command cmdlet to run a Get-Host command.
It uses dot notation to get the Version property of the Windows PowerShell host.

To specify the computers, it uses the Get-Content cmdlet to get the contents of the Machine.txt file, a file of computer names.

These commands run one at a time.
When the commands complete, the output of the commands from all of the computers is saved in the $version variable.
The output includes the name of the computer from which the data originated.

### Example 8: Run a background job on several remote computers
```
PS C:\>$s = New-PSSession -ComputerName Server01, Server02
PS C:\> Invoke-Command -Session $s -ScriptBlock {Get-EventLog system} -AsJob

Id   Name    State      HasMoreData   Location           Command
---  ----    -----      -----         -----------        ---------------
1    Job1    Running    True          Server01,Server02  Get-EventLog system

PS C:\> $j = Get-Job

PS C:\> $j | Format-List -Property *

HasMoreData   : True
StatusMessage :
Location      : Server01,Server02
Command       : Get-EventLog system
JobStateInfo  : Running
Finished      : System.Threading.ManualResetEvent
InstanceId    : e124bb59-8cb2-498b-a0d2-2e07d4e030ca
Id            : 1
Name          : Job1
ChildJobs     : {Job2, Job3}
Output        : {}
Error         : {}
Progress      : {}
Verbose       : {}
Debug         : {}
Warning       : {}
StateChanged  :

PS C:\> $results = $j | Receive-Job
```

These commands run a background job on two remote computers.
Because the Invoke-Command command uses the AsJob parameter, the commands run on the remote computers, but the job actually resides on the local computer and the results are transmitted to the local computer.

The first command uses the New-PSSession cmdlet to create sessions on the Server01 and Server02 remote computers.

The second command uses the Invoke-Command cmdlet to run a background job in each of the sessions.
The command uses the AsJob parameter to run the command as a background job.
This command returns a job object that contains two child job objects, one for each of the jobs run on the two remote computers.

The third command uses a Get-Job command to save the job object in the $j variable.

The fourth command uses a pipeline operator (|) to send the value of the $j variable to the Format-List cmdlet, which displays all properties of the job object in a list.

The fifth command gets the results of the jobs.
It pipes the job object in $j to the Receive-Job cmdlet and stores the results in the $results variable.

### Example 9: Include local variables in a command run on a remote computer
```
PS C:\>$MWFO_Log = "Microsoft-Windows-Forwarding/Operational"
PS C:\> Invoke-Command -ComputerName Server01 -ScriptBlock {Get-EventLog -LogName $Using:MWFO_Log -Newest 10}
```

This example shows how to include the values of local variables in a command run on a remote computer.
The command uses the Using scope modifier to identify a local variable in a remote command.
By default, all variables are assumed to be defined in the remote session.
The Using scope modifier was introduced in Windows PowerShell 3.0.
For more information about the Using scope modifier, see about_Remote_Variables (http://go.microsoft.com/fwlink/?LinkID=252653).

The first command stores the name of the Microsoft-Windows-Forwarding/Operational event log in the $MWFO_Log variable.

The second command uses the Invoke-Command cmdlet to run a Get-EventLog command on the Server01 remote computer that gets the 10 newest events from the Microsoft-Windows-Forwarding/Operational event log on Server01.
The value of the LogName parameter is the $MWFO_Log variable, which is prefixed by the Using scope modifier to indicate that it was created in the local session, not in the remote session.

### Example 10: Hide the computer name
```
PS C:\>Invoke-Command -ComputerName S1, S2 -ScriptBlock {Get-Process PowerShell}

PSComputerName    Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id   ProcessName
--------------    -------  ------    -----      ----- -----   ------     --   -----------
S1                575      15        45100      40988   200     4.68     1392 PowerShell
S2                777      14        35100      30988   150     3.68     67   PowerShell

PS C:\>Invoke-Command -ComputerName S1, S2 -ScriptBlock {Get-Process PowerShell} -HideComputerName

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id   ProcessName
-------  ------    -----      ----- -----   ------     --   -----------
575      15        45100      40988   200     4.68     1392 PowerShell
777      14        35100      30988   150     3.68     67   PowerShell
```

This example shows the effect of using the HideComputerName parameter of Invoke-Command .

The first two commands use Invoke-Command to run a Get-Process command for the PowerShell process.
The output of the first command includes the PsComputerName property, which contains the name of the computer on which the command ran.
The output of the second command, which uses HideComputerName , does not include the PsComputerName column.

Using HideComputerName does not change the object that this cmdlet returns.
It changes only the display.
You can still use the Format cmdlets to display the PsComputerName property of any of the affected objects.

### Example 11: Run a script on all the computers listed in a text file
```
PS C:\>Invoke-Command -ComputerName (Get-Content Servers.txt) -FilePath C:\Scripts\Sample.ps1 -ArgumentList Process, Service
```

This example uses the Invoke-Command cmdlet to run the Sample.ps1 script on all of the computers listed in the Servers.txt file.
The command uses the FilePath parameter to specify the script file.
This command lets you run the script on the remote computers, even if the script file is not accessible to the remote computers.

When you submit the command, the content of the Sample.ps1 file is copied into a script block and the script block is run on each of the remote computers.
This procedure is equivalent to using the ScriptBlock parameter to submit the contents of the script.

### Example 12: Run a command on a remote computer by using a URI
```
PS C:\>$LiveCred = Get-Credential
PS C:\>Invoke-Command -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.exchangelabs.com/PowerShell -Credential $LiveCred -Authentication Basic -ScriptBlock {Set-Mailbox Dan -DisplayName "Dan Park"}
```

This example shows how to run a command on a remote computer that is identified by a URI.
This particular example runs a Set-Mailbox command on a remote Exchange server.
The backtick (\`) in the command is the Windows PowerShell continuation character.

The first command uses the Get-Credential cmdlet to store Windows Live ID credentials in the $LiveCred variable.
A credentials dialog box prompts the user to enter Windows Live ID credentials.

The second command uses the Invoke-Command cmdlet to run a Set-Mailbox command.
The command uses the ConfigurationName parameter to specify that the command should run in a session that uses the Microsoft.Exchange session configuration.
The ConnectionURI parameter specifies the URL of the Exchange server endpoint.

The Credential parameter specifies the Windows Live credentials stored in the $LiveCred variable.
The AuthenticationMechanism parameter specifies the use of basic authentication.
The ScriptBlock parameter specifies a script block that contains the command.

### Example 13: Manage URI redirection in a remote command
```
PS C:\>$max = New-PSSessionOption -MaximumRedirection 1

PS C:\>Invoke-Command -ConnectionUri https://ps.exchangelabs.com/PowerShell -ScriptBlock {Get-Mailbox dan} -AllowRedirection -SessionOption $max
```

This command shows how to use the AllowRedirection and SessionOption parameters to manage URI redirection in a remote command.

The first command uses the New-PSSessionOption cmdlet to create a PSSessionOpption object that it saves in the $Max variable.
The command uses the MaximumRedirection parameter to set the MaximumConnectionRedirectionCount property of the PSSessionOption object to 1.

The second command uses the Invoke-Command cmdlet to run a Get-Mailbox command on a remote server that runs Microsoft Exchange Server.
The command uses the AllowRedirection parameter to provide explicit permission to redirect the connection to an alternate endpoint.
It also uses the SessionOption parameter to specify the session object in the $max variable.

As a result, if the remote computer specified by ConnectionURI returns a redirection message, Windows PowerShell redirects the connection, but if the new destination returns another redirection message, the redirection count value of 1 is exceeded, and Invoke-Command returns a non-terminating error.

### Example 14: Use a session option
```
PS C:\>$so = New-PSSessionOption -SkipCACheck
PS C:\>Invoke-Command -Session $s -ScriptBlock { Get-HotFix } -SessionOption $so -Credential server01\user01
```

This example shows how to create and use a SessionOption parameter.

The first command uses the New-PSSessionOption cmdlet to create a session option.
It saves the resulting SessionOption object in the $so parameter.

The second command uses the Invoke-Command cmdlet to run a Get-HotFix command remotely.
The value of the SessionOption parameter is the SessionOption object in the $so variable.

### Example 15: Access a network share in a remote session
```
PS C:\>Enable-WSManCredSSP -Delegate Server02
PS C:\> Connect-WSMan Server02
PS C:\> Set-Item WSMan:\Server02*\Service\Auth\CredSSP -Value $True
PS C:\> $s = New-PSSession Server02
PS C:\> Invoke-Command -Session $s -ScriptBlock {Get-Item \\Net03\Scripts\LogFiles.ps1} -Authentication CredSSP -Credential Domain01\Admin01
```

This example shows how to access a network share from a remote session.

The command requires that CredSSP delegation be enabled in the client settings on the local computer and in the service settings on the remote computer.
To run the commands in this example, you must be a member of the Administrators group on the local computer and the remote computer.

The first command uses the Enable-WSManCredSSP cmdlet to enable CredSSP delegation from the Server01 local computer to the Server02 remote computer.
This configures the CredSSP client setting on the local computer.

The second command uses the Connect-WSMan cmdlet to connect to the Server02 computer.
This action adds a node for the Server02 computer to the WSMan: drive on the local computer.
This lets you view and change the WS-Management settings on the Server02 computer.

The third command uses the Set-Item cmdlet to change the value of the CredSSP item in the Service node of the Server02 computer to True.
This action enables CredSSP in the service settings on the remote computer.

The fourth command uses the New-PSSession cmdlet to create a PSSession on the Server02 computer.
It saves the PSSession in the $s variable.

The fifth command uses the Invoke-Command cmdlet to run a Get-Item command in the session in $s that gets a script from the Net03\Scripts network share.
The command uses the Credential parameter and it uses the Authentication parameter with a value of CredSSP .

### Example 16: Start scripts on many remote computers
```
PS C:\>Invoke-Command -ComputerName (Get-Content Servers.txt) -InDisconnectedSession -FilePath \\Scripts\Public\ConfigInventory.ps1 -SessionOption @{OutputBufferingMode="Drop";IdleTimeout=43200000}
```

This command runs a script on more than a hundred computers.
To minimize the impact on the local computer, it connects to each computer, starts the script, and then disconnects from each computer.
The script continues to run in the disconnected sessions.

The command uses Invoke-Command to run the script.
The value of the ComputerName parameter is a Get-Content command that gets the names of the remote computers from a text file.
The InDisconnectedSession parameter disconnects the sessions as soon as it starts the command.
The value of the FilePath parameter is the script that Invoke-Command runs on each computer that is named in the Servers.txt file.

The value of SessionOption is a hash table that sets the value of the OutputBufferingMode option to Drop and the value of the IdleTimeout option to 43200000 milliseconds (12 hours).

To get the results of commands and scripts that run in disconnected sessions, use the Receive-PSSession cmdlet.

## PARAMETERS

### -ArgumentList
Supplies the values of local variables in the command.
The variables in the command are replaced by these values before the command is run on the remote computer.
Enter the values in a comma-separated list.
Values are associated with variables in the order that they are listed.
The alias for ArgumentList is Args.

The values in the ArgumentList parameter can be actual values, such as 1024, or they can be references to local variables, such as $max.

To use local variables in a command, use the following command format:

\`{param($\<name1\>\[, $\<name2\>\]...) \<command-with-local-variables\>} -ArgumentList \<value\> -or- \<local-variable\>\`

The param keyword lists the local variables that are used in the command.
ArgumentList supplies the values of the variables, in the order that they are listed.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Command
{{Fill Command Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{Fill Name Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StringOutput
{{Fill StringOutput Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
{{Fill Timeout Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Keine

### System.Management.Automation.ScriptBlock
You can pipe a command in a script block to Invoke-Command .
Use the $Input automatic variable to represent the input objects in the command.

## OUTPUTS

### System.Object
### System.Management.Automation.PSRemotingJob, System.Management.Automation.Runspaces.PSSession, or the output of the invoked command
This cmdlet returns a job object, if you use the AsJob parameter.
If you specify the InDisconnectedSession parameter, Invoke-Command returns a PSSession object.
Otherwise, it returns the output of the invoked command, which is the value of the ScriptBlock parameter.

## NOTES
On Windows Vista, and later versions of the Windows operating system, to use the ComputerName parameter of Invoke-Command * to run a command on the local computer, you must open Windows PowerShell by using the Run as administrator option.

* When you run commands on multiple computers, Windows PowerShell connects to the computers in the order in which they appear in the list. However, the command output is displayed in the order that it is received from the remote computers, which might be different. Errors that result from the command that Invoke-Command * runs are included in the command results. Errors that would be terminating errors in a local command are treated as non-terminating errors in a remote command. This strategy makes sure that terminating errors on one computer do not close the command on all computers on which it is run. This practice is used even when a remote command is run on a single computer.
* If the remote computer is not in a domain that the local computer trusts, the computer might not be able to authenticate the credentials of the user. To add the remote computer to the list of trusted hosts in WS-Management, use the following command in the WSMAN provider, where \<Remote-Computer-Name\> is the name of the remote computer:

\`Set-Item -Path WSMan:\Localhost\Client\TrustedHosts -Value \<Remote-Computer-Name\>\` In Windows PowerShell 2.0, you cannot use the Select-Object cmdlet to select the PSComputerName property of the object that Invoke-Command returns.
Instead, to display the value of the PSComputerName property, use the dot method to get the PSComputerName property value ($result.PSComputerName), use a Format cmdlet, such as the Format-Table cmdlet, to display the value of the PSComputerName * property, or use a Select-Object command where the value of the property parameter is a calculated property that has a label other than PSComputerName.

This limitation does not apply to Windows PowerShell 3.0 or later versions of Windows PowerShell.
When you disconnect a PSSession , such as by using InDisconnectedSession*, the session state is Disconnected and the availability is None.

The value of the State property is relative to the current session.
Therefore, a value of Disconnected means that the PSSession is not connected to the current session.
However, it does not mean that the PSSession is disconnected from all sessions.
It might be connected to a different session.
To determine whether you can connect or reconnect to the session, use the Availability property.

An Availability value of None indicates that you can connect to the session.
A value of Busy indicates that you cannot connect to the PSSession because it is connected to another session.

For more information about the values of the State property of sessions, see RunspaceState Enumerationhttp://msdn.microsoft.com/en-us/library/windows/desktop/system.management.automation.runspaces.runspacestate(v=VS.85).aspx (http://msdn.microsoft.com/en-us/library/windows/desktop/system.management.automation.runspaces.runspacestate(v=VS.85).aspx) in the MSDN library.

For more information about the values of the Availability property of sessions, see RunspaceAvailability Enumerationhttp://msdn.microsoft.com/en-us/library/windows/desktop/system.management.automation.runspaces.runspaceavailability(v=vs.85).aspx (http://msdn.microsoft.com/en-us/library/windows/desktop/system.management.automation.runspaces.runspaceavailability(v=vs.85).aspx) in MSDN.

## RELATED LINKS

[Enter-PSSession]()

[Exit-PSSession]()

[Get-PSSession]()

[New-PSSession]()

[Remove-PSSession]()

