name             'zf2'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
version          '0.7.3'

# baseserver
depends 'baseserver', '~> 0.7.11'

# webserver
depends 'apache2', '~> 3.0.1'
depends 'php', '~> 1.5.0'
depends 'logrotate', '~> 1.8.0'

# database
depends 'database', '~> 2.3.1'
depends 'mysql', '~> 5.6.1'

# frontend
depends 'nodejs', '~> 2.2.0'

# development
depends 'samba', '~> 0.12.0'

# additional for chef-solo
depends 'chef-solo-search', '~> 0.5.1'
