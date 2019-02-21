<#
.NOTES
-------------------------------------------------------------------------------
Script:         ESIDataCollector.ps1
Created With:   Visual Studio Code 2017
Author:         Artemis Dublin
Date:           10/11/2018
Organization:   
File Name:      ESIDataCollector_v4.ps1
Comments:       This script collects electronically stored information (ESI) data
                for use in eDiscovery.
-------------------------------------------------------------------------------
.DESCRIPTION
    - Update the variables defined below 

.UPDATES
    01/11/2019  - Added email notifications

#>

# Change these variables
# -------------------------------------------------------------------------------------------
$LegalRepo          =   "destinationserver01"       # The destination server for the ESI data
$Subdomain          =   ".subdomain.domain.com"     # The fully qualified domain suffix
$Share              =   "staging-area-share"        # The upload folder shared on the legal repo
$PSEmailServer      =   "smtpserver01$Subdomain"    # The hostname of the internal mail relay
# -------------------------------------------------------------------------------------------

$DestinationServer  =   $LegalRepo+$Subdomain
Write-Host " "
$EmailRecipient     =   Read-Host -Prompt 'Enter email for notifications'
Write-Host " "
$SourceMachine      =   Read-Host -Prompt 'Enter Client Machine name'
Write-Host " "
$Custodian          =   Read-Host -Prompt 'Enter Custodian AD username'
Write-Host " "
$ESIDestination     =   "\\$DestinationServer\$Share\CustodianFolders"
$Date               =   get-date -UFormat "%Y%m%d"
$TargetDir          =   "$ESIDestination\$Custodian\"
$Space              =   Write-Host " "

# Get the start time
$StartDTM = (Get-Date)

# Delay for testing
Start-Sleep -s 10

# Initializing bit to false first
$bit = $false

# Send an email notification (starting data collection)
Send-MailMessage -To $EmailRecipient -From $EmailRecipient -Subject "ESI data collection STARTED for ($custodian)" -Body "The ESI data collection script has started for $custodian.`n`nThe server is currently checking if the computer $SourceMachine is online."

# Run loop until Test-Connection is True
while ( $bit -eq $false)
    {
        # Determine if computer is up and running
        Write-Host "--------------------------------------------------"     -ForegroundColor 'Blue'
        Write-Host '    Checking if the computer is online...         '     -ForegroundColor 'Yellow'
        Write-Host "--------------------------------------------------"     -ForegroundColor 'Blue'

        # Checking for the value of Test-Connection (true or false)
        $TestComputerConnection = Test-Connection -count 2 -comp $SourceMachine -Quiet

        # Evaluate $bit
        $bit = $TestComputerConnection
        if ($TestComputerConnection -eq $true)

        # Create a text file of profiles that have logged into the computer
        {Get-ChildItem -Directory "\\$SourceMachine$Subdomain\C$\Users" > "$ESIDestination\$Custodian.txt"

        # Create the destination folder on the DestinationServer if it does not exist
        Write-Host " "
        Write-Host "Creating folder...."                                    -ForegroundColor Green -BackgroundColor Black
        Write-Host " "
            if (!(Test-Path -Path $TargetDir ))
            {
                New-Item -ItemType Directory -Path $TargetDir
            }      

        
# Display the information user provided
Write-Host " "
Write-Host " Robocopying '$SourceMachine' for '$Custodian' on $Date'"
Write-Host " ..........................................................."   -ForegroundColor Blue -BackgroundColor Black
Write-Host " "                                                              -BackgroundColor Black
Write-Host "               Data collection in progress"                     -ForegroundColor Green
Write-Host " "                                                              -BackgroundColor Black
Write-Host " ..........................................................."   -ForegroundColor Blue
Write-Host " "

# Kick off the RoboCopy with the options defined
Write-Host  "Collecting Documents folder content..."                        -ForegroundColor Green -BackgroundColor Black
robocopy "\\$SourceMachine$Subdomain\C$\users\$Custodian\Documents\" "$ESIDestination\$Custodian\Documents\" /z /np   /dcopy:dat /copy:dat /E /XC /XN /XO /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"$ESIDestination\$Custodian\$Custodian.log" /PF /ETA /XJ /EFSRAW /W:33 /R:11
Write-Host $Space
Write-Host  "Documents folder to $DestinationServer has been collected..."  -ForegroundColor Green -BackgroundColor Black
Write-Host $Space
Write-Host  "Collecting Desktop folder content..."                          -ForegroundColor Green -BackgroundColor Black
robocopy "\\$SourceMachine$Subdomain\C$\users\$Custodian\Desktop\" "\$ESIDestination\$Custodian\Desktop\" /z /np   /dcopy:dat /copy:dat /E /XC /XN /XO /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"$ESIDestination\$Custodian\$Custodian.log" /PF /ETA /XJ /EFSRAW /W:33 /R:11
Write-Host $Space
Write-Host  "Desktops folder to $DestinationServer has been collected..."   -ForegroundColor Green -BackgroundColor Black
Write-Host $Space
Write-Host  "Collecting Downloads folder content..."                        -ForegroundColor Green -BackgroundColor Black
robocopy "\\$SourceMachine$Subdomain\C$\users\$Custodian\Downloads\" "$ESIDestination\$Custodian\Downloads\" /z /np   /dcopy:dat /copy:dat /E /XC /XN /XO /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"$ESIDestination\$Custodian\$Custodian.log" /PF /ETA /XJ /EFSRAW /W:33 /R:11
Write-Host $Space
Write-Host  "Downloads folder to $DestinationServer has been collected..."  -ForegroundColor Green -BackgroundColor Black
Write-Host $Space
Write-Host  "Collecting Music folder content..."                            -ForegroundColor Green -BackgroundColor Black
robocopy "\\$SourceMachine$Subdomain\C$\users\$Custodian\Music\" "$ESIDestination\$Custodian\Music\" /z /np   /dcopy:dat /copy:dat /E /XC /XN /XO /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"$ESIDestination\$Custodian\$Custodian.log" /PF /ETA /XJ /EFSRAW /W:33 /R:11
Write-Host $Space
Write-Host  "Music folder to $DestinationServer has been collected..."      -ForegroundColor Green -BackgroundColor Black
Write-Host $Space
Write-Host  "Collecting Pictures folder content..."                         -ForegroundColor Green -BackgroundColor Black
robocopy "\\$SourceMachine$Subdomain\C$\users\$Custodian\Pictures\" "$ESIDestination\$Custodian\Pictures\" /z /np   /dcopy:dat /copy:dat /E /XC /XN /XO /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"$ESIDestination\$Custodian\$Custodian.log" /PF /ETA /XJ /EFSRAW /W:33 /R:11
Write-Host $Space
Write-Host  "Pictures folder to $DestinationServer has been collected..."   -ForegroundColor Green -BackgroundColor Black
Write-Host $Space
Write-Host  "Collecting Videos folder content..."                           -ForegroundColor Green -BackgroundColor Black
robocopy "\\$SourceMachine$Subdomain\C$\users\$Custodian\Videos\" "$ESIDestination\$Custodian\Videos\" /z /np   /dcopy:dat /copy:dat /E /XC /XN /XO /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /log+:"$ESIDestination\$Custodian\$Custodian.log" /PF /ETA /XJ /EFSRAW /W:33 /R:11
Write-Host $Space
Write-Host  "Videos folder to $DestinationServer has been collected..."     -ForegroundColor Green -BackgroundColor Black
Write-Host $Space
Write-Host  "Collecting remaining folder content..."                        -ForegroundColor Green -BackgroundColor Black
robocopy "\\$SourceMachine$Subdomain\C$\users\$Custodian\" "$ESIDestination\$Custodian\" /z /np   /dcopy:dat /copy:dat /E /XC /XN /XO /xD Documents /xD Desktop /xD Downloads /xD Music /xD Pictures /xD Videos /xD WebCache /xf NTUser.* /xf UsrClass.* /xf *.pst /xf WebCache*.dat /xf *.dat /xf V*.log /xf edb.log /xf *.ost /xf *.tmp /xf "Current Session.*" /xf "Current Tabs.*" /xf IndexedDB.edb /xf IndexDB.jfm /xf Report.wer /xf Temp.edb /xf Internet.edb /xf RecoveryStore.*.dat /xf *.nst /xf *.jfm /log+:"$ESIDestination\$Custodian\$Custodian.log" /PF /ETA /XJ /EFSRAW /W:33 /R:11
Write-Host $Space
Write-Host  "Remaining files to $DestinationServer has been collected..."   -ForegroundColor Green -BackgroundColor Black

# Get the end time
$EndDTM = (Get-Date)

# Calculate time elapsed
$Time = "exactly: $(($EndDTM - $StartDTM).totalminutes) minutes"

# Send an email notification (data collection ended)
Send-MailMessage -To $EmailRecipient -From $EmailRecipient -Subject "ESI data collection ENDED for ($custodian)" -Body "The ESI data collection script has ended for $custodian on computer $SourceMachine.`n`nTotal elapsed time for the data collection $Time"

# Display total time of data collection
Write-Host " "                                                              -BackgroundColor Black
Write-Host " Data collection for $Custodian has been collected....."        -ForegroundColor Green -BackgroundColor Black
Write-Host " "                                                              -BackgroundColor Black
Write-Host " Total elapsed time for the data collection $Time        "      -ForegroundColor Blue -BackgroundColor Black
Write-Host " "                                                              -BackgroundColor Black
    }   
}
