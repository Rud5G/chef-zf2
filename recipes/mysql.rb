#
# Cookbook Name:: zf2
# Recipe:: mysql
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


mysql2_chef_gem 'default' do
  action :install
end


Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# var
initial_root_passwd = secure_password

node.set_unless['mysql']['server_root_password'] = initial_root_passwd
node.save unless Chef::Config[:solo]

node.set_unless['mysql']['serverinstance'] = 'default'
node.save unless Chef::Config[:solo]



mysql_client 'default' do
  action :create
end


defaultmysqlinstance = 'default'

mysql_service defaultmysqlinstance do
  version '5.6'
  bind_address '0.0.0.0'
  port '3306'
  initial_root_password node['mysql']['server_root_password']
  data_dir '/var/lib/mysql'
  action [:create, :start]
end

