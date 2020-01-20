#######################################################################################
####                                                                               ####
####                     LUC BESSON'S MOVIE'S SCRIPT GENERATOR                     ####
####                                                                               ####
#######################################################################################

# The goal of this script is to generate a movie's script based on simple constructs and
# a dictonary.

#######################################################################################
#
#   0. PARAMETERS
#
#######################################################################################

Param (
    [Parameter (Mandatory = $false, HelpMessage = "Provide the path to the dictonary json file")]
    [string]$dictionaryPath = ".\dictionary.json"
)

#######################################################################################
#
#   1. VARIABLE AND PRE-EXECUTION
#
#######################################################################################

$inputFile = $dictionaryPath | Split-Path -Leaf
Write-Verbose "Getting dictionary object from $inputFile"
if (Test-Path -Path $dictionaryPath -PathType "leaf") {
    $dictionaryObject = get-content $dictionaryPath | ConvertFrom-Json
} else {
    Write-Error "Error while loading dictionary file" -ErrorAction Stop
}

Write-Verbose "Loading dictionary"
$heroList = $dictionaryObject.hero
$actionList = $dictionaryObject.action
$foeList = $dictionaryObject.foe
$objectList = $dictionaryObject.object
$placeList = $dictionaryObject.place

Write-Verbose "Setting "
$hero = $heroList[$(Get-Random -Maximum $heroList.Length)-1]
$action = $actionList[$(Get-Random -Maximum $actionList.Length)-1]
$foe = $foeList[$(Get-Random -Maximum $foeList.Length)-1]
$object = $objectList[$(Get-Random -Maximum $objectList.Length)-1]
$place = $placeList[$(Get-Random -Maximum $placeList.Length)-1]

Write-Output "$($hero) $($action) $($foe) with a $($object) in $($place)"