Function Get-DynamicRemoteSession {
    [OutputType([Management.Automation.Runspaces.PSSession[]])]
    Param()

    # We get our calling function
    $stack = Get-PSCallStack
    $caller = $stack[1]

    # This is a hashmap of the parameters sent into the calling function
    $callerParams = $caller.InvocationInfo.BoundParameters

    if ($callerParams["Session"]) {
        return $callerParams["Session"]
    } elseif ($callerParams["ComputerName"]) {
        $sessionList = @()
        foreach ($name in $callerParams["ComputerName"]) {
            $cred = @{}
            if ($callerParams["Credential"]) { $cred["Credential"] = $callerParams["Credential"]}
            $sessionList += New-PSSession -ComputerName $name @cred
        }
        return $sessionList
    } else {
        return
    }
}