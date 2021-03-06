#
# Cookbook Name:: service_layer
# Recipe:: init_z.rb
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

powershell_script "mount_z" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
$NewDiskNumber = 1
$NewDiskLabel="Scratch"
 
$diskpart_command = $Null
$diskpart_command = @"
SELECT DISK $NewDiskNumber
ATTRIBUTES DISK CLEAR READONLY
ONLINE DISK
CONVERT MBR
CREATE PARTITION PRIMARY ALIGN=64
ASSIGN LETTER=#{node['service_layer']['windowsDrive']}
"@
$diskpart_command | diskpart
Format-Volume -DriveLetter #{node['service_layer']['windowsDrive']} -FileSystem NTFS -NewFileSystemLabel $NewDiskLabel -Confirm:$false

New-Item -ItemType Directory -Force -Path #{node['service_layer']['windowsDrive']}:\\Mounted

  EOH
  not_if { ::File.directory?("#{node['service_layer']['windowsDrive']}:/Mounted") }
end