#
# Cookbook Name:: service_layer
# Recipe:: mongodb
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

windows_package 'mongodb' do
  source "https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-#{node['service_layer']['mongodb']['version']}-signed.msi"
  options 'INSTALLLOCATION="C:\mongodb" ADDLOCAL="MonitoringTools,ImportExportTools,MiscellaneousTools"'
  remote_file_attributes {
    :path => "C:\\mongodb.msi",
    :checksum => node['service_layer']['mongodb']['checksum']
  }
end

directory "#{node['service_layer']['mongodb']['data_dir']}/db" do
  action :create
end

directory "#{node['service_layer']['mongodb']['data_dir']}/log" do
  action :create
end

template 'C:\mongodb\mongod.cfg' do
  source 'mongod.cfg.erb'
  variables(
    :data_dir => node['service_layer']['mongodb']['data_dir'],
    :replSetName => node['service_layer']['mongodb']['replSetName']
  )
end

powershell "Create MongoDB service" do
  code <<-EOH
  sc.exe create MongoDB binPath= "C:\mongodb\bin\mongod.exe --service --config=\"C:\mongodb\mongod.cfg\"" DisplayName= "MongoDB" start= "auto"
  EOH
  action :run
end

windows_service 'MongoDB' do
  action :configure_startup
  startup_type :automatic
end