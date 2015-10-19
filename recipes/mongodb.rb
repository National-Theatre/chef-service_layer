#
# Cookbook Name:: service_layer
# Recipe:: mongodb
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

require 'win32/service'
include_recipe "windows_firewall::default"

remote_file "C:\\mongodb.msi" do
  source "https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-#{node['service_layer']['mongodb']['version']}-signed.msi"
  checksum node['service_layer']['mongodb']['checksum']
  action :create_if_missing
end

windows_package 'mongodb' do
  source "C:\\mongodb.msi"
  options 'INSTALLLOCATION="C:\mongodb" ADDLOCAL="MonitoringTools,ImportExportTools,MiscellaneousTools"'
  not_if { ::File.directory?("C:\\Program Files\\MongoDB\\Server\\3.0") }
end

directory "#{node['service_layer']['mongodb']['data_dir']}" do
  action :create
end

directory "#{node['service_layer']['mongodb']['data_dir']}/db" do
  action :create
end

directory "#{node['service_layer']['mongodb']['data_dir']}/log" do
  action :create
end

directory 'C:\mongodb' do
  action :create
end

template 'C:\mongodb\mongod.cfg' do
  source 'mongod.cfg.erb'
  variables(
    :data_dir => node['service_layer']['mongodb']['data_dir'],
    :replSetName => node['service_layer']['mongodb']['replSetName'],
    :opsProfileMode => node['service_layer']['mongodb']['operationProfiling']['mode']
  )
end

batch "Create MongoDB service" do
  code 'sc.exe create MongoDB binPath= "\"C:\Program Files\MongoDB\Server\3.0\bin\mongod.exe\" --service --config=\"C:\mongodb\mongod.cfg\"" DisplayName= "MongoDB" start= "auto"'
  action :run
  not_if { ::Win32::Service.exists?('MongoDB') }
end

windows_service 'MongoDB' do
  action [:configure_startup, :start]
  startup_type :automatic
end

windows_firewall_rule 'MongoDB' do
  localport '27017'
  protocol 'TCP'
  firewall_action :allow
  profile :any
end