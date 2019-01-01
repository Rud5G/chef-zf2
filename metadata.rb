name 'zf2'
maintainer 'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license 'Apache-2.0'
description 'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
issues_url 'https://github.com/Rud5G/chef-zf2/issues'
source_url 'https://github.com/Rud5G/chef-zf2'
chef_version '>= 12.7' if respond_to?(:chef_version)
version '0.13.2'

# support
supports 'ubuntu'

# baseserver
# version is in Berksfile
depends 'baseserver'

depends 'swap', '~> 2.2.2'

# webserver
depends 'apache2', '~> 5.2.1'
depends 'php', '~> 6.1.1'

# database
depends 'mysql2_chef_gem', '~> 2.1.0'
depends 'database', '~> 6.1.1'
depends 'mysql', '~> 8.5.2'

depends 'openssl', '~> 8.5.5'

# line
depends 'line', '~> 2.1.1'
depends 'logrotate', '~> 2.2.0'

# frontend
depends 'nodejs', '~> 6.0.0'

# development
depends 'samba', '~> 1.2.0'
#depends 'samba', '~> 0.13.0'
# depends 'samba', '~> 1.0.6'


