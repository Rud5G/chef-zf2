name 'zf2'
maintainer 'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license 'Apache 2.0'
description 'Installs/Configures ZF2'
long_description 'Installs/Configures ZF2'
issues_url 'https://github.com/Rud5G/chef-zf2/issues' if respond_to?(:issues_url)
source_url 'https://github.com/Rud5G/chef-zf2' if respond_to?(:source_url)
version '0.12.11'

# support
supports 'ubuntu'

# baseserver
depends 'baseserver', '~> 0.9.3'

depends 'swap', '~> 2.0.0'

# webserver
depends 'apache2', '~> 3.3.0'
depends 'php', '~> 3.1.0'

# database
depends 'mysql2_chef_gem', '~> 2.0.1'
depends 'database', '~> 6.1.1'
depends 'mysql', '~> 8.3.1'

depends 'openssl', '~> 7.0.1'

# line
depends 'line', '~> 0.6.3'

# frontend
depends 'nodejs', '~> 3.0.0'

# development
depends 'samba', '~> 0.13.0'

