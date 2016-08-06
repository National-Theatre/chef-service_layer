#
# Cookbook Name:: service_layer
# Recipe:: mongodb_install
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

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
