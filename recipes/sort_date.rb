#
# Cookbook Name:: service_layer
# Recipe:: sort_date
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

batch "set_time_gmt" do
  code 'tzutil.exe /s "GMT Standard Time"'
end

batch "register_ntp" do
  code 'w32tm /register'
  action :nothing
  notifies :run, 'powershell_script[enable_ntp]', :immediately
end

batch "set_ntp" do
  code 'w32tm /config /manualpeerlist:"0.amazon.pool.ntp.org 1.amazon.pool.ntp.org uk.pool.ntp.org" /update'
  action :nothing
end

powershell_script 'enable_ntp' do
  code <<-EOH
  Start-Service w32time
  EOH
  action :nothing
  notifies :run, 'batch[set_ntp]', :immediately
end

registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\Parameters" do
  values [{
    :name => "NtpServer",
    :type => :string,
    :data => '0.amazon.pool.ntp.org 1.amazon.pool.ntp.org uk.pool.ntp.org'
  }]
  action :create
  notifies :run, 'batch[register_ntp]', :immediately
end
