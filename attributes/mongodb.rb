#
# Cookbook Name:: service_layer
# Attributes:: mongodb
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['service_layer']['mongodb']['version'] = '3.2.8'
default['service_layer']['mongodb']['checksum'] = '4fdf9ce389fb865127cbbe3023477f125c66c0105f2dad35f1563c4bda7279ec'
default['service_layer']['mongodb']['data_dir'] = 'D:\data'
default['service_layer']['mongodb']['replSetName'] = 'test-rep'
default['service_layer']['mongodb']['operationProfiling']['mode'] = 'off'
