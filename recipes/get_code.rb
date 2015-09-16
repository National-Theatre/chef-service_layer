#
# Cookbook Name:: service_layer
# Recipe:: get_code
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

powershell_script "get_code" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
Read-S3Object -BucketName #{node['service_layer']['code_bucket']} -Key ServiceLayer.zip -File #{node['service_layer']['windowsDrive']}:\\ServiceLayer.zip
New-Item -ItemType Directory -Force -Path #{node['service_layer']['windowsDrive']}:\\ServiceLayer

$shell=new-object -com shell.application
$location=$shell.namespace('#{node['service_layer']['windowsDrive']}:\\ServiceLayer')
 
# test the root folder now does exist, extract if it does.
if($location){
     $zipFiles = get-childitem #{node['service_layer']['windowsDrive']}:\\ServiceLayer.zip
     Write-Host "Number of ZIPs=$($zipFiles.count)" -fore yellow -back black
 
     foreach($zipFile in $ZipFiles){
          Write-Host "`t$($zipFile.fullname)" -fore green
          $zipFolder = $shell.namespace($zipFile.fullname)
          Write-Host "unzipping..." -fore green -back black
          $location.Copyhere($zipFolder.items())
     }
 
}else{
    Write-Host 'Oh Snap! - file path could not be created'
}

  EOH
  not_if { ::File.directory?("#{node['service_layer']['windowsDrive']}:/ServiceLayer") }
end

batch "run_installer batch" do
  cwd "#{node['service_layer']['windowsDrive']}:\\ServiceLayer"
  code <<-EOH
#{node['service_layer']['windowsDrive']}:\\ServiceLayer\\ServiceLayer.API.deploy.cmd "/Y"
  EOH
  not_if { ::File.directory?("#{node['service_layer']['path']}/Configuration") }
end

powershell_script "run_installer" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  & #{node['service_layer']['windowsDrive']}:/ServiceLayer/ServiceLayer.API.deploy.cmd "/Y"
  EOH
  not_if { ::File.directory?("#{node['service_layer']['path']}/Configuration") }
end

ruby_block "run_installer ruby" do
  block do
    if system("#{node['service_layer']['windowsDrive']}:\\ServiceLayer\\ServiceLayer.API.deploy.cmd \"/Y\"")
      print 'TRUE!!!!'
    else
      print 'FALSE!!!!'
    end
  end
  not_if { ::File.directory?("#{node['service_layer']['path']}/Configuration") }
  action :run
end

