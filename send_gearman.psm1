<#
.Synopsis
    Send a packet to a gearmand server.
.Description 
    This powershell cmdlet allows to inject results to a monitoring system with GearmanD. (mod-gearman)
	
.Parameter $server
    IP address/hostname of the gearman server
.Parameter $port
    TCP Port of the gearman server (default: 4730)
.Parameter $key
    Encryption key
.Parameter $hostname
    Nagios hostname
.Parameter $servicename
    Nagios servicename
.Parameter $output
    Output of the Check to submit
.Parameter $statuscode
    statuscode of the check to submit
.Parameter $queuename
    Name of the result queue (default: check_results)
.Parameter $debug
    Debug (Default: no)

.Link
    FIXME
.Example
    Import-Module send_gearman
	send_gearman -server $GearmanServer -key "wrzlbrmpft" -hostname "myhost" -servicename "mysvc" -output "OK: All tests passed." -statuscode 0
		
#>

# C:\Users\simon_meggle\AppData\Local\Temp\2
$logging = $true
$logfile = "send_gearman.psm1.log"

function send_gearman{
	param (
            [Parameter(Mandatory=$true)]
            [String]$server = "",
            [int]$port = "4730",
            [Parameter(Mandatory=$true)]
            [string]$key = "",
            [Parameter(Mandatory=$true)]
            [string]$hostname = "",
            [string]$servicename = "",
            [Parameter(Mandatory=$true)]
            [string]$output = "",            
            [Parameter(Mandatory=$true)]
            [string]$statuscode = "",            
            [string]$queuename = "check_results"
    )
    Write-Log "send_gearman.windows.amd64.exe --server=$($server):$($port) --key=$key --encryption --host=$hostname --service=$servicename --returncode=$statuscode --message=`"$($output)`""
    
    # send_gearman.windows.amd64.exe (Go-EXE)
    # Do not use "Start-Process -NoNewWindow ..." here. If executed within a Start-Job, only one execution will 
    # be done and the script will exit completely. 
    # Solution for this is "-WindowStyle -Hidden". This behaves almost the same but works. 
    # https://stackoverflow.com/questions/24689505/start-process-nonewwindow-within-a-start-job?noredirect=1&lq=1
    # Use -Wait to serialize the calls. Otherwise the binary will tear down the whole script with OOM: 
    # "runtime: VirtualAlloc of 1048576 bytes failed with errno=1455; fatal error: out of memory
    Start-Process -WindowStyle Hidden -Wait -FilePath "$PSScriptRoot/send_gearman.windows.amd64.exe" -ArgumentList "--server=$($server):$($port) --key=$key --encryption --host=$hostname --service=`"$servicename`" --returncode=$statuscode --message=`"$($output)`""

    # send_gearman.exe (Perl-EXE)
    #Start-Process -NoNewWindow -Wait -FilePath "$PSScriptRoot/send_gearman.exe" -ArgumentList "--server $($server):$($port) --key=$key --encryption --host=$hostname --service=$servicename --returncode=$statuscode --message=`"$($output)`"" 
    
    Start-Sleep 0.8
}

function send2gearman([string]$GearmanServer, [string]$GearmanKey, [string]$hostname, [string]$service, [string]$output, [int]$status) {
    send_gearman -server $GearmanServer -key $GearmanKey -hostname "$hostname" -servicename "$service" -output "$output" -statuscode $status
}


function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
		[string]$Message,
		
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$file = "$logfile"		
    )
    if ($logging -eq $true) {
        $LogTime = Get-Date -Format "MM-dd-yy hh:mm:ss"
        "$logTime $Message" >> "$env:Temp\$file"
    }
}