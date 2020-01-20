#######################################################################################
####                                                                               ####
####                            TEST json ARM templates                            ####
####                                                                               ####
#######################################################################################

# The goal of this script is to check ARM template file for syntax errors or unnecessary
# content inherited from a portal export.

#######################################################################################
#
#   0. PARAMETERS
#
#######################################################################################

Param (
    [Parameter (Mandatory = $false, HelpMessage = "Provide the path to the templates")]
    [string]$path = "..\Templates"
)

#######################################################################################
#
#   1. VARIABLE AND PRE-EXECUTION
#
#######################################################################################

$testPath = Test-Path $path
if ($testPath -eq $false) {
    Write-Error "The provided path does not exist" -ErrorAction "Stop"
}

#######################################################################################
#
#   2. EXECUTION
#
#######################################################################################

Get-ChildItem -Path $path -Recurse -Include *.json | ForEach-Object {
    $file = $_
    Write-Output "Checking syntax for file $($file.Name)"
    try {
        $jsonContent = Get-Content "$($file.FullName)"
        $jsonContentObject = $jsonContent | ConvertFrom-Json -ErrorAction "Stop"
        $jsonResources = $jsonContentObject.resources
        Write-Host "No syntax issue"
        $jsonContent = $null
    }
    catch {
        $jsonError = $_.Exception
        Write-Host "##vso[task.LogIssue type=error;]Syntax issues were found in file $($file.Name) : $($jsonError.Message)"
    }

    Write-Verbose "Checking for unnecessary comments"
    $CommentsProperty = $jsonResources | Where-Object -Property "comments" -Match "Generalized"
    if ($CommentsProperty) {
        Write-Host "##vso[task.LogIssue type=error;]The template contains unnecessary 'comments' from portal export"
    }

    Write-Verbose "Checking for scale properties"
    $ScaleProperty = Select-String -Path "$($file.FullName)" -SimpleMatch "scale"
    if ($ScaleProperty) {
        Write-Host "##vso[task.LogIssue type=error;]The template contains unnecessary 'scale' properties from portal export"
    }
    
    Write-Verbose "Checking for provisioningState properties"
    $provisioningStateProperty = Select-String -Path "$($file.FullName)" -SimpleMatch "provisioningState"
    if ($provisioningStateProperty) {
        Write-Host "The template contains unnecessary 'provisioningStateProperty' properties from portal export"
    }
    
    Write-Verbose "Checking for creationTime properties"
    $creationTimeProperty = Select-String -Path "$($file.FullName)" -SimpleMatch "creationTime"
    if ($creationTimeProperty) {
        Write-Host "The template contains unnecessary 'creationTime' properties from portal export"
    }
}
if ($jsonError) {
    exit 1
}