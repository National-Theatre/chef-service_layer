#
# Cookbook Name:: service_layer
# Recipe:: fix_newrelic
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

remote_file 'C:\\NewRelicDotNetAgent_x64.msi' do
  source 'https://download.newrelic.com/dot_net_agent/latest_release/NewRelicDotNetAgent_x64.msi'
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
  notifies :run, "powershell_script[reset_iis]", :delayed
  not_if { ::File.directory?('C:\\Program Files\\New Relic\\.NET Agent') }
end

template "C:\\ProgramData\\New Relic\\.NET Agent\\newrelic.config" do
  source 'newrelic.config.erb'
  variables({
    :licenseKey => node['newrelic']['license'],
    :AsyncMode => node['service_layer']['newrelic']['async'],
    :LogLevel => node['service_layer']['newrelic']['LogLevel']
  })
  notifies :run, "powershell_script[reset_iis]", :delayed
end

template "C:\\ProgramData\\New Relic\\.NET Agent\\Extensions\\ServiceLayerInstrumentation.xml" do
  source 'ServiceLayerInstrumentation.xml.erb'
  notifies :run, "powershell_script[reset_iis]", :delayed
end

powershell_script "reset_iis" do
  code <<-EOH
  iisreset
  EOH
  action :nothing
end
