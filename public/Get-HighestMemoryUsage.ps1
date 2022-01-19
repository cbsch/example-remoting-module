Function Get-HighestMemoryUsage {
    Param(
        [Parameter()][int]$Top = 5
    )

    Get-Process |
        Sort-Object WorkingSet -Descending |
        Select-Object -First $Top Id, Name, WorkingSet
}

Set-Item -Path Function:script:Get-HighestMemoryUsage -Value (
    New-RemoteFunction (Get-Command Get-HighestMemoryUsage)
)