name             'zf2'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
version          '0.10.4'


# support
%w( ubuntu ).each do |os|
  supports os
end


# baseserver
depends 'baseserver', '~> 0.8.7'

depends 'swap', '~> 0.3.8'

# webserver
depends 'apache2', '~> 3.2.2'
depends 'php', '~> 1.8.0'
depends 'logrotate', '~> 1.9.2'

# database
depends 'mysql2_chef_gem', '~> 1.0'
depends 'database', '~> 5.1.2'
depends 'mysql', '~> 7.0.0'

depends 'openssl', '~> 4.4.0'

# line
depends 'line', '~> 0.6.3'

# frontend
depends 'nodejs', '~> 2.4.4'

# development
depends 'samba', '~> 0.12.0'