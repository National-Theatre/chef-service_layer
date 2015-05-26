#
# Cookbook Name:: service_layer
# Recipe:: sort_date
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

batch "set_time_gmt" do
  code "tzutil.exe /s 'GMT Standard Time'"
end