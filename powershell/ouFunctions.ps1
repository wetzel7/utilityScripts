# Author: Logan Savage
# Class: SYS-265, Champlain College
# Yo, I made this
# :)

Write-Host "This is a menu script to create and delete Organization Units, as well as Move Objects"
$Prompt = "Choose a Menu Item to proceed:`n"
$Prompt += "1 - Add an OU`n"
$Prompt += "2 - Delete an OU`n"
$Prompt += "3 - Move a computer object`n"
$Prompt += "4 - Move a user object`n"
$Prompt += "5 - Exit`n"


$operation = $true

while($operation){
    Write-Host $Prompt | Out-String 
    $choose = Read-Host

    if($choose -eq 1){
            
        $NameOU = Read-Host -Prompt "Please enter a name for your New OU"

        $ouExists = Get-ADOrganizationalUnit -Filter "Name -eq '$NameOU'"

        if($ouExists) {
            Write-Host "OU exists prior"
        } 
        else{
                New-ADOrganizationalUnit -Name "$NameOU" -ProtectedFromAccidentalDeletion $FALSE
                Write-Host "OU Created"
                }
        }

    elseif($choose -eq 2){

        $DeleteOU = Read-Host "Enter the name of the OU you would like to delete (ex OU=TestOU,DC=logan,DC=local)"
        
        if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $DeleteOU})) {
            Remove-ADOrganizationalUnit -Identity $DeleteOU -Confirm:$false
            Write-Output "OU '$DeleteOU' deleted"
            } 

        else {
            Write-Host "Failed: OU $DeleteOU not found"
             }
    }

    elseif($choose -eq 3){

        $DCComputer = Read-Host "Hostname of computer you'd like to move (ex. wks01-logan)"
        $PlacementOU = Read-Host "Placement OU for computer (ex OU=TestOU,DC=logan,DC=local)"

        $compCheck = Get-ADComputer -Identity $DCComputer

        if ($compCheck -ne $null) {
            Move-ADObject -Identity $compCheck -TargetPath $PlacementOU
            Write-Output "'$DCComputer' Moved to '$PlacementOU'"
            }
        else {
            Write-Host "Failed: '$DCComputer' not found"
            }
    }

    elseif($choose -eq 4){
    
        
        $DCUser = Read-Host "Hostname of user you'd like to move (ex. logan.savage)"
        $PlacementOU = Read-Host "Placement OU for user (ex OU=TestOU,DC=logan,DC=local)"

        $userCheck = Get-ADUser -Identity $DCUser

        if ($userCheck -ne $null) {
            Move-ADObject -Identity $userCheck -TargetPath $PlacementOU
            Write-Output "'$DCUser' Moved to '$PlacementOU'"
            }
        else {
            Write-Host "Failed: '$DCUser' not found"
            }
    }

    elseif($choose -eq 5){

        Write-Host "Exiting" | Out-String
        exit
        $operation = $false
    }

    else{
        clear
        Write-Host "Not a valid input"

        }
}