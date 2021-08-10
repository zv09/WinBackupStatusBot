
. C:\Users\Администратор\Documents\GitHub\WinBackupStatusBot\TelegramBotSettings.ps1   #Load file with your personal Telegram credentials

function Tg-SendMessage #Telegram messaging gadget scripted on PowerShell
{ 
    param (
        $Data,
        $TokenID,
        $ChatID
        #$Node
    )

    $payload = @{
        "chat_id" = $ChatID;
        "text" = "$Data";
        "parse_mode" = 'html';
        "disable_notification"= $false;
        }
    
    [System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3") #Telegram servers protocol requirements
    Invoke-RestMethod `
       -Uri ("https://api.telegram.org/bot{0}/sendMessage" -f $TokenID) `
       -Method Post `
       -ContentType "application/json;charset=utf-8" `
       -Body (ConvertTo-Json -Compress -InputObject $payload)

}

$FilterEvents = "
<QueryList>
  <Query Id='0' Path='Microsoft-Windows-Backup'>
    <Select Path='Microsoft-Windows-Backup'>    
        *[System[Provider[@Name='Microsoft-Windows-Backup'] and (EventID=1 or EventID=14) and TimeCreated[timediff(@SystemTime) &lt; 120000]]]
    </Select>
  </Query>
</QueryList>"

# 60000 - 1 min
# 120000 - 2 min
# 180000 - 3 min
# 3600000 - 1 hour
# 86400000 - 1 day
# 172800000 - 2 days
# 604800000 - 7 days

$Events = Get-WinEvent -FilterXml $FilterEvents  #Query the Server Logs for filtered Backup events.

$EventItems = @() #Structured data block /an array/ for storing filtered Event items.

Foreach ($Entry in $Events) #Do iterate to search last neccesary Event in the Events Log database.
  {  	
    $EventID = $Entry.Id #Extract Event ID for choosing message content
    	
	$EventTime = $Entry.TimeCreated.ToString("dd-MM-yyyy HH:mm:ss") #Extract Event time was generated and convert it to standard format

    $EventNode = $Entry.MachineName #Extract Node name

    If ($EventID -eq 1) #Backup operation started status catch-up and send notification 
    {
        $EventItems += @("Backup Status for <b>$EventNode</b>`nOperation started at $EventTime")    
    } #If Event 1 END
    
    If ($EventID -eq 14) #Analyze backup complete code and send notification 
    {
    	$EventHResult = $Entry.Properties[1].Value #Extract HResult as the operation status code

        $EventStartTime = $Entry.Properties[5].Value.ToString("dd-MM-yyyy HH:mm:ss") #Extract Backup starting time 

        If ($EventHResult -eq 0x0) #Filtering out successful buckup and prepare the message
            {
            $EventItems += @("Backup Status for <b>$EventNode</b>`nOperation started at $EventStartTime`nwas finished at $EventTime <b>successfully</b>.`n")
            }

        else #If EventHResult not equal 0 then backup fail
            {
            $EventItems += @("Backup Status for <b>$EventNode</b>`nOperation started at $EventStartTime`nwas finished at $EventTime`nStatus: <b>Failed (!)</b> Code: $('0x{0:X}' -f ([Int] $EventHResult))`n")
            }
    } #If Event 14 END

  } #Foreach END

if ($EventItems.count -eq 0) { exit 0 } #If no Events were found, exit immediately and don't send message

#Telegram Messaging
Tg-SendMessage "$EventItems" "$TokenID" "$ChatID"