<#     
.NOTES 
#=========================================================================================== 
# Script: ESI-Collection.ps1  
# Created With:ISE 3.0  
# Author: Artemis Dublin 
# Date: 07/11/2018  
# Organization:  Company Name
# Comments:  Robocopy windows user directory from client device to legal repository server
#=========================================================================================== 
.DESCRIPTION               
        Change $Dest_PC = "(legal-repository)"    
#> 
                
$Space           = Write-host ""
$Dest_PC         = "fully.qualified.domainname.com"
$sourceMachine   = Read-Host -Prompt 'Enter Client Machine Name'
$custodian       = Read-Host -Prompt 'Enter Custodian AD username'
$dest            = "\\$Dest_PC\C$\staging\$custodian"
$Logfile         = "ESI-Collection-$date.txt"
$date            = Get-Date -UFormat "%Y%m%d"
$options         = @("/LOG:\\$Dest_PC\C$\staging\$custodian\$logfile")

## Get Start Time
$startDTM = (Get-Date)

## Create Folder on the Target Server if it does not exist

$TARGETDIR   = "\\$Dest_PC\C$\staging\$custodian\"

# Create destination folder! It does not exist on the Destination PC 

Write-host "Creating Folder....." -fore Green -back black
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
}

Write-Host "RoboCopying '$custodian' (Custodian) from '$sourceMachine' (Primary Machine) on '$date'"

Write-Host "........................................." -Fore Blue

## Provide Information
Write-host "Copying folder into $Dest_PC....................." -fore Green -back black
Write-Host "........................................." -Fore Blue

## Kick off the RoboCopy with options defined

robocopy "\\$sourceMachine.fqdn.domain.com\c$\users\$custodian\Documents\" "\\$Dest_PC\C$\staging\$custodian\Documents\" /z /np /s /copy:dat  /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"\\$Dest_PC\C$\staging\$custodian\$custodian.log" /PF /ETA /XJ /EFSRAW /W:10 /R:10
Write-host $space
Write-host " Documents folder to $Dest_PC has been completed......" -fore Green -back black
Write-host $space
robocopy "\\$sourceMachine.fqdn.domain.com\c$\users\$custodian\Desktop\" "\\$Dest_PC\C$\staging\$custodian\Desktop\" /z /np /s /copy:dat  /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"\\$Dest_PC\C$\staging\$custodian\$custodian.log" /PF /ETA /XJ /EFSRAW /W:10 /R:10
Write-host $space
Write-host " Desktop folder to $Dest_PC has been completed......" -fore Green -back black
Write-host $space
robocopy "\\$sourceMachine.fqdn.domain.com\c$\users\$custodian\Downloads\"  "\\$Dest_PC\C$\staging\$custodian\Downloads\" /z /np /s /copy:dat  /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"\\$Dest_PC\C$\staging\$custodian\$custodian.log" /PF /ETA /XJ /EFSRAW /W:10 /R:10
Write-host $space
Write-host " Downloads folder to $Dest_PC has been completed......" -fore Green -back black
Write-host $space
robocopy "\\$sourceMachine.fqdn.domain.com\c$\users\$custodian\Music\" "\\$Dest_PC\C$\staging\$custodian\Music\" /z /np /s /copy:dat  /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"\\$Dest_PC\C$\staging\$custodian\$custodian.log" /PF /ETA /XJ /EFSRAW /W:10 /R:10
Write-host $space
Write-host " Music folder to $Dest_PC has been completed......" -fore Green -back black
Write-host $space
robocopy "\\$sourceMachine.fqdn.domain.com\c$\users\$custodian\Pictures\" "\\$Dest_PC\C$\staging\$custodian\Pictures\" /z /np /s /copy:dat  /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"\\$Dest_PC\C$\staging\$custodian\$custodian.log" /PF /ETA /XJ /EFSRAW /W:10 /R:10
Write-host $space
Write-host " Pictures folder to $Dest_PC has been completed......" -fore Green -back black
Write-host $space
robocopy "\\$sourceMachine.fqdn.domain.com\c$\users\$custodian\Videos"  "\\$Dest_PC\C$\staging\$custodian\Videos" /z /np /s /copy:dat  /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"\\$Dest_PC\C$\staging\$custodian\$custodian.log" /PF /ETA /XJ /EFSRAW /W:10 /R:10
Write-host $space
Write-host " Videos folder to $Dest_PC has been completed......" -fore Green -back black
Write-host $space
robocopy "\\$sourceMachine.fqdn.domain.com\c$\users\$custodian\"  "\\$Dest_PC\LC\staging\$custodian\" /z /np /s /copy:dat  /xD Documents /xD Desktop /xD Downloads /xD Music /xD Pictures /xD Videos /xD WebCache /xf NTUser.* /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf *.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /xf "Current Session.*" /xf "Current Tabs.*" /xf IndexedDB.edb /xf IndexDB.jfm /xf Report.wer /xf Temp.edb /xf Internet.edb /xf RecoveryStore.*.dat /xf *.nst /xf *.jfm /log+:"\\$Dest_PC\C$\staging\$custodian\$custodian.log" /PF /ETA /XJ /EFSRAW /w:10 /R:10

## Get End Time
$endDTM = (Get-Date)

## Echo Time elapsed
$Time = "Elapsed Time: $(($endDTM-$startDTM).totalminutes) minutes"

## Provide time it took
Write-host ""
Write-host " Copy folder to $Dest_PC has been completed......" -fore Green -back black
Write-host " Copy folder to $Dest_PC took $Time        ......" -fore Blue
