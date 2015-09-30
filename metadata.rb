name             'zf2'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
version          '0.9.7'

# baseserver
depends 'baseserver', '~> 0.8.5'

# webserver
depends 'apache2', '~> 3.1.0'
depends 'php', '~> 1.7.0'

# database
depends 'mysql2_chef_gem', '~> 1.0'
depends 'database', '~> 4.0.8'
depends 'mysql', '~> 6.0'

# line
depends 'line', '~> 0.6.2'

# frontend
depends 'nodejs', '~> 2.4.0'

# development
depends 'samba', '~> 0.12.0'
