name             'zf2'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
version          '0.11.2'


# support
%w( ubuntu ).each do |os|
  supports os
end


# baseserver
depends 'baseserver', '~> 0.8.8'

depends 'swap', '~> 0.3.8'

# webserver
depends 'apache2', '~> 3.2.2'
depends 'php', '~> 2.1.1'

# database
depends 'mysql2_chef_gem', '~> 1.0'
depends 'database', '~> 5.1.2'
depends 'mysql', '~> 7.0'

depends 'openssl', '~> 6.0.0'

# line
depends 'line', '~> 0.6.3'

# frontend
depends 'nodejs', '~> 2.4.4'

# development
depends 'samba', '~> 0.12.0'
