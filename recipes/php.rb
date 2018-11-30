#
# Cookbook Name:: zf2
# Recipe:: php
#
# Copyright (C) 2013 MagentoRotterdam
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'php::default'

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