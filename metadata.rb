name             'service_layer'
maintainer       'National Theatre'
maintainer_email 'jpdrawneek@nationaltheatre.org.uk'
license          'All rights reserved'
description      'Installs/Configures service_layer'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.13'
supports         'windows'
depends          'iis'
depends          'windows'
depends          'iis_urlrewrite'
depends          'windows_firewall'