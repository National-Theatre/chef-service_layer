#
# Cookbook Name:: service_layer
# Recipe:: wake_tessitura.rb
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
# 

cookbook_file "WakeTessituraUp.xml" do
  path "C:/WakeTessituraUp.xml"
  action :create
end
execute "slave_task" do
  command "schtasks /Create /TN \"Wake Tessitura Up\" /RU SYSTEM /F /xml C:/WakeTessituraUp.xml"
end