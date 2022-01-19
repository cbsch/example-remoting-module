#requires -version 7

$ROOT_FOLDER = Resolve-Path "$PSScriptRoot\.."
$functions = Get-ChildItem -Recurse -Path $ROOT_FOLDER\public
| Select-Object -ExpandProperty BaseName `
| Sort-Object

$functionsText = $functions
| % { "'$_'" }
| Join-String -Separator ",`n$(" " * 8)"
$functionsText = "@(`n$(" " * 8)$functionsText`n$(" " * 4))"

$module = "$ROOT_FOLDER\RemotingTest.psd1"
$moduleText = Get-Content $module -Raw -Encoding utf8
if ($moduleText -match "(?s)FunctionsToExport = (.*\))") {
    $moduleText.Replace($matches[1], $functionsText)
    | Set-Content -Encoding utf8 -Path $module
}