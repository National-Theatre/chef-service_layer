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
  notifies :restart, "iis_site[Service Layer]", :delayed
  notifies :restart, "iis_pool[service_layer_pool]", :delayed
end

template "#{node['service_layer']['path']}/Configuration/NLog.config" do
  source 'NLog.config.erb'
  variables({
    :minlevel        => node['service_layer']['NLog']['minLevel'],
    :archiveEvery    => node['service_layer']['NLog']['archiveEvery'],
    :maxArchiveFiles => node['service_layer']['NLog']['maxArchiveFiles']
  })
  notifies :restart, "iis_site[Service Layer]", :delayed
  notifies :restart, "iis_pool[service_layer_pool]", :delayed
end

template "#{node['service_layer']['path']}/Configuration/ConnectionStrings.config" do
  source 'ConnectionStrings.config.erb'
  variables({
    :config => node['service_layer']['ConnectionStrings']
  })
  notifies :restart, "iis_site[Service Layer]", :delayed
  notifies :restart, "iis_pool[service_layer_pool]", :delayed
end

template "#{node['service_layer']['path']}/Configuration/Smtp.config" do
  source 'Smtp.config.erb'
  variables({
    :config => node['service_layer']['Smtp']
  })
  notifies :restart, "iis_site[Service Layer]", :delayed
  notifies :restart, "iis_pool[service_layer_pool]", :delayed
end

template "#{node['service_layer']['path']}/Configuration/system.servicemodel.bindings.config" do
  source 'system.servicemodel.bindings.config.erb'
  variables({
    :config => node['service_layer']['servicemodel']
  })
  notifies :restart, "iis_site[Service Layer]", :delayed
  notifies :restart, "iis_pool[service_layer_pool]", :delayed
end

template "#{node['service_layer']['path']}/Configuration/system.servicemodel.client.config" do
  source 'system.servicemodel.client.config.erb'
  variables({
    :config => node['service_layer']['servicemodel']
  })
  notifies :restart, "iis_site[Service Layer]", :delayed
  notifies :restart, "iis_pool[service_layer_pool]", :delayed
end

iis_config "/section:applicationPools /[name='service_layer_pool'].processModel.idleTimeout:0.00:00:00" do
    action :set
end
