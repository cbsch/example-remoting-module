Function _RemoteTemplate {
    [CmdletBinding()]
    # We need to replace this with the parameters of the wrapped function,
    # in addition to parameters needed for the remoting
    Param()

    Begin {
        # This is a function that will extract bound parameters
        # from its calling function (this function) and either return
        # the session that was passed in, or create a new one.
        $sessionList = Get-DynamicRemoteSession

        $sessionList | % {
            # Here we need replace {ArgumentList} with the names of the parameters we added
            # to the Param block at the top
            Invoke-Command -Session $_ -ArgumentList {ArgumentList} -ScriptBlock {{ScriptBlock}}
        }
    }
    End {
        # If we created a session, this function will remove it
        Remove-DynamicRemoteSession -Session $sessionList
    }
}