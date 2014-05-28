#
# Cookbook Name:: zf2
# Recipe:: php
#
# Copyright (C) 2013 MagentoRotterdam
#
# All rights reserved - Do Not Redistribute
#


# repository is also added to default, because of the issue:
# installing php5.3 during compiletime. and never installing php5.4

apt_repository 'php-5.4' do
  uri          'http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'E5267A6C'
  only_if { node['php']['set_version'] == '5.4' }
end

include_recipe 'php'

