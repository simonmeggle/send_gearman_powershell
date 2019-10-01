This Powershell module allows to inject results from a windows machine to a monitoring system with GearmanD. (mod-gearman, see https://labs.consol.de/omd/)


# Installation

Download the psm1 and .exe file into `~\Documents\WindowsPowershell\Modules\send_gearman` or simply run this one line installation script:

	iex ((new-object net.webclient).DownloadString("https://raw.githubusercontent.com/simonmeggle/send_gearman_powershell/master/install.ps1"))

This will also download and install the compiled go binary `send_gearman.windows.amd64.exe`. If you want to compile your own binary go to https://github.com/ConSol/mod-gearman-worker-go and use the Makefile there. 

# Usage

    Import-Module send_gearman
	send_gearman -server $GearmanServer -key "wrzlbrmpft" -hostname "myhost" -servicename "mysvc" -output "OK: All tests passed." -statuscode 0

See data.gearman for an example file for a packet with multiple results. 
