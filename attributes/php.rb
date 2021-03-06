#
# Cookbook Name:: zf2
# Attribute:: php
#
# Copyright (C) 2014 Triple-networks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# php
case node['platform_family']
  when 'debian'
    case node['platform']
      when 'ubuntu'
        case node['platform_version'].to_f
          when 13.04..15.10

            default['php']['enable_mod'] = '/usr/sbin/php5enmod'
            default['php']['disable_mod'] = '/usr/sbin/php5dismod'
            default['php']['ext_conf_dir'] = '/etc/php5/mods-available'

            default['php']['packages'] = %w(
              curl
              libxml2-utils
              php-pear
              php-apc
              phpmyadmin
              php5
              php5-cli
              php5-common
              php5-curl
              php5-dev
              php5-gd
              php5-intl
              php5-mcrypt
              php5-mysql
              php5-xmlrpc
              php5-xsl
              libapache2-mod-php5
              php5-zip
              zip
              unzip
            )

          when 16.04

            default['php']['enable_mod']       = '/usr/sbin/phpenmod'
            default['php']['disable_mod']      = '/usr/sbin/phpdismod'
            default['php']['ext_conf_dir']     = '/etc/php/7.0/mods-available'

            default['php']['packages'] = %w(
              curl
              libxml2-utils
              php-pear
              phpmyadmin
              php
              php-cli
              php-common
              php-curl
              php-dev
              php-gd
              php-intl
              php-mcrypt
              php-mysql
              php-xmlrpc
              php-xsl
              libapache2-mod-php
              php-zip
              zip
              unzip
            )

          else
            # dont change anything.
        end
      else
        # dont change anything.
    end
  else
    # dont change anything.
end
