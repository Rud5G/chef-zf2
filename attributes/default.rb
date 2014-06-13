#
# Cookbook Name:: zf2
# Attribute:: default
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

# ::Chef::Node.send(:include, Opscode::OpenSSL::Password)


default['parent'] = default[:cookbook_name]


# apache2
default['apache']['default_site_enabled'] = true #false

default['apache']['default_modules'] = %w[
  status alias auth_basic autoindex
  dir env mime negotiation setenvif
  mod_deflate mod_expires mod_headers mod_php5 mod_rewrite
]

#  default['apache']['listen_addresses']              #- Addresses that httpd should listen on. Default is any ("*").
#  default['apache']['listen_ports']                  #- Ports that httpd should listen on. Default is port 80.
#  default['apache']['contact']                       #- Value for ServerAdmin directive. Default "ops@example.com".
#  default['apache']['timeout']                       #- Value for the Timeout directive. Default is 300.
#  default['apache']['keepalive']                     #- Value for the KeepAlive directive. Default is On.
#  default['apache']['keepaliverequests']             #- Value for MaxKeepAliveRequests. Default is 100.
#  default['apache']['keepalivetimeout']              #- Value for the KeepAliveTimeout directive. Default is 5.
#  default['apache']['sysconfig_additional_params']   #- Additionals variables set in sysconfig file. Default is empty.
#  default['apache']['default_modules']               #- Array of module names. Can take "mod_FOO" or "FOO" as names, where FOO is the apache module, e.g. "mod_status" or "status".
# The modules listed in default_modules will be included as recipes in recipe[apache::default].


# php
default['php']['set_version'] = '5.4'
default['php']['packages'] = %w(
  curl libxml2-utils
  php-pear php-apc
  phpmyadmin
  php5 php5-cli php5-common php5-curl php5-dev php5-gd php5-intl php5-mcrypt php5-mysql php5-xmlrpc php5-xsl
)
