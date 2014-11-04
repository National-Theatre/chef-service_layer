#
# Cookbook Name:: service_layer
# Recipe:: app_config
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

template "#{node['service_layer']['path']}/Configuration/AppSettings.config" do
  source 'AppSettings.config.erb'
  variables({
    :config => node['service_layer']['AppSettings']
  })
  notifies :restart, "iis_app[Service Layer]", :delayed
end

template "#{node['service_layer']['path']}/Configuration/NLog.config" do
  source 'NLog.config.erb'
  variables({
    :minlevel        => node['service_layer']['NLog']['minLevel'],
    :archiveEvery    => node['service_layer']['NLog']['archiveEvery'],
    :maxArchiveFiles => node['service_layer']['NLog']['maxArchiveFiles']
  })
  notifies :restart, "iis_app[Service Layer]", :delayed
end

template "#{node['service_layer']['path']}/Configuration/ConnectionStrings.config" do
  source 'ConnectionStrings.config.erb'
  variables({
    :config => node['service_layer']['ConnectionStrings']
  })
  notifies :restart, "iis_app[Service Layer]", :delayed
end
