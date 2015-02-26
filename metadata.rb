name             'zf2'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
version          '0.6.1'

depends 'baseserver', '~> 0.7.10'

depends 'php', '~> 1.5.0'
depends 'database', '~> 4.0.2'
depends 'mysql', '~> 6.0.13'
depends 'apache2', '~> 3.0.1'

depends 'nodejs'

# development
depends 'samba', '~> 0.12.0'

# additional for chef-solo
depends 'chef-solo-search', '~> 0.5.1'

