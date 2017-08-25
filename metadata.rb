name 'zf2'
chef_version '>= 12.7'
maintainer 'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license 'Apache-2.0'
description 'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
issues_url 'https://github.com/Rud5G/chef-zf2/issues'
source_url 'https://github.com/Rud5G/chef-zf2'
version '0.12.12'

# support
supports 'ubuntu'

# baseserver
# version is in Berksfile
depends 'baseserver'

depends 'swap', '~> 2.1.0'

# webserver
depends 'apache2', '~> 5.0.0'
depends 'php', '~> 4.5.0'

# database
depends 'mysql2_chef_gem', '~> 2.1.0'
depends 'database', '~> 6.1.1'
depends 'mysql', '~> 8.5.1'

depends 'openssl', '~> 7.1.0'

# line
depends 'line', '~> 1.0.3'
depends 'logrotate', '~> 2.2.0'

# frontend
depends 'nodejs', '~> 4.0.0'

# development
depends 'samba', '~> 0.13.0'
# depends 'samba', '~> 1.0.6'


