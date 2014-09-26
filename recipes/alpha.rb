#
# Cookbook Name:: service_layer
# Recipe:: alpha
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

include_recipe "service_layer::init_z"

include_recipe "service_layer::_init"

directory node['service_layer']['path'] do
  action :create
  not_if { ::File.directory?(node['service_layer']['path']) }
end

#creates a new app pool
iis_pool 'service_layer_pool' do
  runtime_version "4.0"
  pipeline_mode :Integrated
  action [:add,:start]
end 
# IIS vhost
iis_site 'Service Layer' do
  protocol :http
  port 80
  path node['service_layer']['path']
  host_header "data.ntstaging.org.uk"
  application_pool "service_layer_pool"
  action [:add,:start]
end

powershell_script "fix_iis_handler" do
  code "Set-WebConfiguration //System.webServer/handlers -metadata overrideMode -value Allow -PSPath IIS:/"
end

include_recipe "service_layer::get_code"

include_recipe "service_layer::app_config"