#
# Cookbook Name:: service_layer
# Recipe:: discovery
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

#creates a new app pool
iis_pool 'service_layer_pool' do
  runtime_version "4.0"
  pipeline_mode :Integrated
  action [:add,:start]
end 
#creates a new app
iis_app "Default Web Site" do
  path "/ServiceLayer.API_deploy"
  application_pool "service_layer_pool"
  physical_path "z:\ServiceLayer.API_deploy"
  enabled_protocols "http"
  action :add
end