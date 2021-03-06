#
# Cookbook Name:: service_layer
# Recipe:: live
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

include_recipe "service_layer::init_z"

include_recipe "service_layer::_init"

directory node['service_layer']['path'] do
  action :create
  not_if { ::File.directory?(node['service_layer']['path']) }
end

# IIS vhost
iis_site 'Service Layer' do
  path node['service_layer']['path']
  bindings "http/*:80:ntapi.nationaltheatre.org.uk,http/*:80:localhost"
  application_pool "service_layer_pool"
  site_name "Service Layer"
  action [:add,:start]
end

powershell_script "fix_iis_handler" do
  code "Set-WebConfiguration //System.webServer/handlers -metadata overrideMode -value Allow -PSPath IIS:/"
end

powershell_script "fix_iis_rew" do
  code "Set-WebConfiguration //System.webServer/rewrite/allowedServerVariables -metadata overrideMode -value Allow -PSPath IIS:/"
end

include_recipe "service_layer::get_code"

include_recipe "service_layer::app_config"