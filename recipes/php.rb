#
# Cookbook Name:: zf2
# Recipe:: php
#
# Copyright (C) 2013 MagentoRotterdam
#
# All rights reserved - Do Not Redistribute
#

# python-software-properties
# add-apt-repository ppa:ondrej/php

# apt_repository 'php' do
#   uri   'ppa:ondrej/php'
#   distribution node['lsb']['codename']
#   components   ['main']
#   keyserver    'keyserver.ubuntu.com'
#   key          'E5267A6C'
# end

include_recipe 'php'

socket_ini = 'mysql.default_socket'
socket_file = '/run/mysql-default/mysqld.sock'

template File.join(node['php']['ext_conf_dir'], 'chefzf2.ini') do
  source 'php-module.ini.erb'
  variables modulelines: {
      socket_ini => socket_file
  }
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute "#{node['php']['enable_mod']} chefzf2" do
  only_if { platform?('ubuntu') && ::File.exist?(node['php']['enable_mod']) }
end