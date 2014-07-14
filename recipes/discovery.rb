#
# Cookbook Name:: service_layer
# Recipe:: discovery
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

windows_package 'webdeploy' do
  source node['windows']['webdeploy']
  action :install
end

%w{ NetFx4 NetFx4ServerFeatures NetFx4Extended-ASPNET45 IIS-ASPNET45 IIS-NetFxExtensibility45 }.each do |feature|
  windows_feature feature do
    action :install
    all true
  end
end

directory "Z:\\ServiceLayer.API_deploy" do
  action :create
  not_if { ::File.directory?("Z:\\ServiceLayer.API_deploy") }
end

#creates a new app pool
iis_pool 'service_layer_pool' do
  runtime_version "4.0"
  pipeline_mode :Integrated
  action [:add,:start]
end 
#creates a new app
iis_app "Default Web Site" do
  path "/ServiceLayer.API_deploy"
  application_pool "service_layer_pool"
  physical_path "Z:\\ServiceLayer.API_deploy"
  enabled_protocols "http"
  action :add
end

powershell_script "fix_iis_handler" do
  code "Set-WebConfiguration //System.webServer/handlers -metadata overrideMode -value Allow -PSPath IIS:/"
end

powershell_script "get_code" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
Read-S3Object -BucketName ntdp-artifact -Key ServiceLayer.zip -File Z:\ServiceLayer.zip
New-Item -ItemType Directory -Force -Path Z:\ServiceLayer

$shell=new-object -com shell.application
$location=$shell.namespace('Z:\ServiceLayer')
 
# test the root folder now does exist, extract if it does.
if($location){
     $zipFiles = get-childitem Z:\ServiceLayer.zip
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
& Z:\ServiceLayer\ServiceLayer.API.deploy.cmd "/Y"
  EOH
  not_if { ::File.directory?("Z:\\ServiceLayer") }
end

template "z:/ServiceLayer.API_deploy/Configuration/AppSettings.config" do
  source 'AppSettings.config.erb'
  variables({
    :config => node['service_layer']['AppSettings']
  })
end