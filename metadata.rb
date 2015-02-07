name             'zf2'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
version          '0.6.0'

depends 'baseserver', '~> 0.7.10'

depends 'php', '~> 1.4.6'
depends 'database', '~> 2.3.1'
depends 'mysql', '~> 5.6.1'
depends 'apache2', '~> 1.11.0'

depends 'nodejs'

# development
depends 'samba', '~> 0.12.0'

# additional for chef-solo
depends 'chef-solo-search', '~> 0.5.1'

