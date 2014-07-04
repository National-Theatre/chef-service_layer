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
