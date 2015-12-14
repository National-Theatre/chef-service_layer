#
# Cookbook Name:: service_layer
# Recipe:: _init.rb
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

#creates a new app pool
iis_pool 'service_layer_pool' do
  runtime_version "4.0"
  pipeline_mode :Integrated
  action [:add,:start]
  idle_timeout '00:00:00'
  idle_timeout_action :Suspend
end
