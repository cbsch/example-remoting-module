Function New-RemoteFunction {
    Param(
        [Parameter(Mandatory)][Management.Automation.FunctionInfo]$FunctionInfo
    )
    $fi = $FunctionInfo

    # Keep a list of the names of the parameters, so we can pass them into the Invoke-Command
    $parameterNameList = @()

    # Prepare the remoting parameters to be added to the wrapper function
    $parameterLines = @(
        "[Parameter(Mandatory, ParameterSetName=`"ComputerName`")][string[]]`$ComputerName",
        "[Parameter(ParameterSetName=`"ComputerName`")][PSCredential]`$Credential",
        "[Parameter(Mandatory, ParameterSetName=`"Session`")] `
        [Management.Automation.Runspaces.PSSession[]]`$Session"
    )

    # Loop through the parameters in the AST and get the strings representing
    # the parameter names and definitions.
    if ($fi.ScriptBlock.Ast.Body.ParamBlock.Parameters) {
        $fi.ScriptBlock.Ast.Body.ParamBlock.Parameters | % {
            $parameterLines += $_.Extent.Text
            $parameterNameList += $_.Name.Extent.Text
        }
    }

    $paramText = "Param(`n" + ($parameterLines -join ",`n") + "`n)"
    $argumentList = ($parameterNameList | % { "$_"}) -join ", "

    # Get the text of our template function and replace the placeholders
    $def = (Get-Item Function:\_RemoteTemplate).Definition
    $def = $def.Replace("Param()", $paramText)
    $def = $def.Replace("{ScriptBlock}", (Get-Command $($FunctionInfo.Name)).ScriptBlock)
    $def = $def.Replace("{ArgumentList}", "@(" + $argumentList + ")")

    # Create the ScriptBlock and return it
    return [ScriptBlock]::Create($def)
}