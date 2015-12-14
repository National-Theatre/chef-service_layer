#
# Cookbook Name:: service_layer
# Recipe:: fix_newrelic
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

remote_file 'C:\\NewRelicDotNetAgent_x64.msi' do
  source 'https://download.newrelic.com/dot_net_agent/release/NewRelicDotNetAgent_x64.msi'
  action :create
end

windows_package "Install New Relic .NET Agent" do
#  action [:install]
#  default_guard_interpreter :default
  options "/qb NR_LICENSE_KEY=#{node['newrelic']['license']} INSTALLLEVEL=50"
#  package_name "Install New Relic .NET Agent"
  source "C:\\NewRelicDotNetAgent_x64.msi"
#  timeout 600
#  returns [0]
#  declared_type :windows_package
#  cookbook_name :newrelic
#  recipe_name "dotnet_agent"
  notifies :restart, "iis_site[Service Layer]", :delayed
  notifies :restart, "iis_pool[service_layer_pool]", :delayed
  not_if { ::File.directory?('C:\\Program Files\\New Relic\\.NET Agent') }
end

powershell_script "reset_iis" do
  code <<-EOH
  iisreset
  New-Item c:\newrelic.txt -type file
  EOH
  not_if { ::File.exists?("C:\\newrelic.txt") }
end