#
# Cookbook Name:: service_layer
# Attributes:: discovery
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['windows']['webdeploy'] = 'http://download.microsoft.com/download/D/4/4/D446D154-2232-49A1-9D64-F5A9429913A4/WebDeploy_amd64_en-US.msi'
default['service_layer']['AppSettings']['TessituraAnonUname']        = 'changeme'
default['service_layer']['AppSettings']['TessituraAnonPword']        = 'changeme'
default['service_layer']['AppSettings']['TessituraWarnTimeout']      = 2000
default['service_layer']['AppSettings']['TessituraExceptionTimeout'] = 10000
default['service_layer']['NLog']['minLevel']                         = 'Debug'

