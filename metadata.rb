name             'zf2'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
version          '0.5.1'

depends 'baseserver', '~> 0.7.10'

depends 'mysql', '~> 5.2.12'
depends 'apache2', '~> 1.11.0'
depends 'php', '~> 1.4.6'
depends 'database', '~> 2.2.0'

depends 'nodejs'
depends 'samba'

# additional for chef-solo
depends 'chef-solo-search', '~> 0.5.1'

