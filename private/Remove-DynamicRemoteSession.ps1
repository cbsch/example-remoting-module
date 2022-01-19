Function Remove-DynamicRemoteSession {
    Param(
        [Management.Automation.Runspaces.PSSession[]]$Session
    )

    $stack = Get-PSCallStack
    $caller = $stack[1]

    $callerParams = $caller.InvocationInfo.BoundParameters

    if ($callerParams["ComputerName"] -and $Session) {
        $Session | Remove-PSSession
    }
}