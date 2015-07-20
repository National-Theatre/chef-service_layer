#
# Cookbook Name:: service_layer
# Attributes:: mongodb
#
# Copyright 2015, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['service_layer']['mongodb']['version'] = '3.0.4'
default['service_layer']['mongodb']['checksum'] = '6efed258ae5d6944ca52724f16dd4f0334de3cbc8f3018af190963f9a88f9b8e'
default['service_layer']['mongodb']['data_dir'] = 'z:\data'
default['service_layer']['mongodb']['replSetName'] = 'test-rep'