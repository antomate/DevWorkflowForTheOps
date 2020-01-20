#######################################################################################
####                                                                               ####
####                            TEST PowerShell scripts                            ####
####                                                                               ####
#######################################################################################

# The goal of this script is to check PowerShell scripts with PSScriptAnalyzer.

#######################################################################################
#
#   0. PARAMETERS
#
#######################################################################################

Param (
    [Parameter (Mandatory = $false, HelpMessage = "Provide the path to the templates")]
    [string]$path = "..\Scripts"
)

#######################################################################################
#
#   1. VARIABLE AND PRE-EXECUTION
#
#######################################################################################

Install-Module PSScriptAnalyzer -Confirm:$false -Force -Repository "PSGallery" -SkipPublisherCheck

$testPath = Test-Path $path
if ($testPath -eq $false) {
    Write-Error "The provided path does not exist" -ErrorAction "Stop"
}

#######################################################################################
#
#   2. EXECUTION
#
#######################################################################################

Get-ChildItem -Path $path -Recurse -Include *.ps1 | ForEach-Object {
    $file = $_
    Write-Output "Checking syntax for file $($file.Name)"
    $scriptAnalysis = Invoke-ScriptAnalyzer -Path "$($file.FullName)" -ReportSummary
}