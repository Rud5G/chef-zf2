#
# Cookbook Name:: zf2
# Recipe:: php
#
# Copyright (C) 2013 MagentoRotterdam
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'php'

# Chef::Recipe.send(:include, MysqlCookbook::Helpers)
# Chef::Resource::Line.send(:include, MysqlCookbook::Helpers)
# Chef::Resource::Mysql.send(:include, MysqlCookbook::Helpers)
# Chef::Node.send(:include, MysqlCookbook::Helpers)
# Chef::Resource::Mysql.send(:include, MysqlCookbook::Helpers)
# thesocketfile = socket_file
# Chef::Log.info("database helper: #{thesocketfile}")

# todo: replace with MysqlCookbook::Helpers socket_file
socket_file = "/run/mysql-default/mysqld.sock"

append_if_no_line 'set-php-apache2-mysql.default_socket' do
  path File.join(File.dirname(node['php']['conf_dir']), 'apache2', 'php.ini')
  line 'mysql.default_socket = ' + socket_file
end

append_if_no_line 'set-php-cli-mysql.default_socket' do
  path File.join(File.dirname(node['php']['conf_dir']), 'cli', 'php.ini')
  line 'mysql.default_socket = ' + socket_file
end
