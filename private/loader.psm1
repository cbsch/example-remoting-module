Get-ChildItem $PSScriptRoot/*.ps1 | % { . $_ }
Get-ChildItem $PSScriptRoot/../public/*.ps1 | % { . $_ }