#
# Cookbook Name:: service_layer
# Recipe:: _init.rb
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

windows_package 'webdeploy' do
  source node['windows']['webdeploy']
  action :install
end

%w{ NetFx4 NetFx4ServerFeatures NetFx4Extended-ASPNET45 IIS-ASPNET45 IIS-NetFxExtensibility45 }.each do |feature|
  windows_feature feature do
    action :install
    all true
  end
end
