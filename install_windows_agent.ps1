# ------------------------------------------------------------------------------------------
# This is a powershell userdata script used to bootstrap Amazon's Windows AMI's with 
# RightScale's server agent called RightLink (https://github.com/rightscale/right_link)
# ------------------------------------------------------------------------------------------

# Check if RightLink is installed:
$isInstalled = gwmi win32_service | where {$_.name -like "Rightlink"}
if ($isInstalled)
{
	Write-Output "RightLink is already installed, exitting"
	Exit 0
}

# Download Rightlink Installer
$folder = "c:\temp\rightlink"
mkdir -force $folder 
cd $folder 
$fileUrl = "http://mirror.rightscale.com/rightscale_rightlink/latest/windows/Rightscale_Windows_x64_5.8.8.msi"
$fileName = "$folder\" + $fileUrl.Split('/')[-1]
(new-object System.Net.WebClient).DownloadFile($fileUrl, $fileName )


# Run installer
$logfile = $folder  + "\RightLinkInstall.log"
$cmd =  "start-process -wait ""$fileName"" -ArgumentList ""/norestart /qn /l* $logfile"""
iex $cmd
gc $logfile 
start-service rightlink
