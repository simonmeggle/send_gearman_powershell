$modulespath = ($env:psmodulepath -split ";")[0]
$send_gearmanpath = "$modulespath\send_gearman"

Write-Host "Creating module directory"
New-Item -Type Container -Force -path $send_gearmanpath | out-null

Write-Host "Downloading and installing"
(new-object net.webclient).DownloadString("https://github.com/simonmeggle/send_gearman_powershell/raw/master/send_gearman.windows.amd64.exe") | Select-Object -ExpandProperty Content | Out-File "$send_gearmanpath\send_gearman.windows.amd64.exe" 
(new-object net.webclient).DownloadString("https://raw.githubusercontent.com/simonmeggle/send_gearman_powershell/master/send_gearman.psm1") | Out-File "$send_gearmanpath\send_gearman.psm1" 

Write-Host "Installed!"
