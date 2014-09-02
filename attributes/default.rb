#
# Cookbook Name:: service_layer
# Attributes:: discovery
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['windows']['webdeploy'] = 'http://download.microsoft.com/download/D/4/4/D446D154-2232-49A1-9D64-F5A9429913A4/WebDeploy_amd64_en-US.msi'
default['service_layer']['path']                                     = 'Z:/ServiceLayer.API_deploy'
default['service_layer']['iis_pool']                                 = 'service_layer_pool'
default['service_layer']['URL']                                      = '/ServiceLayer.API'
default['service_layer']['AppSettings']['TessituraAnonUname']        = 'changeme'
default['service_layer']['AppSettings']['TessituraAnonPword']        = 'changeme'
default['service_layer']['AppSettings']['TessituraWarnTimeout']      = 2000
default['service_layer']['AppSettings']['TessituraExceptionTimeout'] = 10000
default['service_layer']['AppSettings']['ApiRootClientTimeout']      = 60
default['service_layer']['AppSettings']['ApiRootServerTimeout']      = 60
default['service_layer']['AppSettings']['WhatsOnClientTimeout']      = 60
default['service_layer']['AppSettings']['WhatsOnServer']             = 240
default['service_layer']['AppSettings']['TessituraIpAddress']        = 'localhost'
default['service_layer']['AppSettings']['TessituraBusinessUnit']     = 1
default['service_layer']['NLog']['minLevel']                         = 'Debug'
default['service_layer']['NLog']['archiveEvery']                     = 'Day'
default['service_layer']['NLog']['maxArchiveFiles']                  = 14
default['service_layer']['ConnectionStrings']['MongoDB']             = 'mongodb://localhost:27017'
default['service_layer']['ConnectionStrings']['RedisCache']          = 'localhost'
