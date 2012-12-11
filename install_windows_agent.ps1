# ------------------------------------------------------------------------------------------
# License and Authors
# ===================
#
# Author:: Ameer Deen (ameer.deen@cloudoman.com)
#
# Copyright:: 2011-2012, Cloudoman PTY LTD.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------------------------------------


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
