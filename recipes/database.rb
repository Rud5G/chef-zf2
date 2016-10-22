#
# Cookbook Name:: zf2
# Recipe:: database
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


package 'libmysqlclient-dev' do
  action :install
end

# provides mysql gem resource
mysql2_chef_gem 'default' do
  action :install
end

# Configure the MySQL service.
mysql_service 'default' do
  version node['mysql']['version']
  bind_address '0.0.0.0'
  port '3306'
  initial_root_password node['mysql']['server_root_password']
  # provider MysqlCookbook::MysqlServiceManagerSystemd
  service_manager 'systemd'
  action [:create, :start]
end


# Configure the MySQL client.
mysql_client 'default' do
  version node['mysql']['version']
  action :create
end

# Configure databases
begin
  data_bag('databases').each do |database|
    database_bagitem = data_bag_item('databases', database)
    databasedata = database_bagitem[node.chef_environment]

    Chef::Log.info("Cookbook #{cookbook_name} in the recipe: #{recipe_name}.")
    Chef::Log.info(databasedata.to_hash)

    begin
      database_connection = {
          :port => databasedata['port']
      }

      case databasedata['type']
        when 'mysql'

          # serverinstance = databasedata['serverinstance'] || 'default'
          # socket_file = "/run/mysql-#{serverinstance}/mysqld.sock"

          database_connection.merge!({
              :host => databasedata['host'],
              :port => databasedata['port'],
              :username => 'root',
              :password => node['mysql']['server_root_password']
          })
          # :socket   => socket_file,

          # Create the database instance.
          mysql_database databasedata['dbname'] do
            connection database_connection
            action :create
          end

          # set the secure_passwords
          if databasedata['password'].nil?
            Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

            database_bagitem[node.chef_environment]['password'] = secure_password
            database_bagitem.save unless Chef::Config[:solo]
            databasedata['password'] = database_bagitem[node.chef_environment]['password']

            Chef::Log.info("database password #{databasedata['dbname']} reset")
          end

          # Add a database user.
          mysql_database_user databasedata['username'] do
            connection database_connection
            password databasedata['password']
            database_name databasedata['dbname']
            host '%'
            action [:create, :grant]
          end
        else
          # this is now a feature
          Chef::Log.info("Unmanaged database type: #{databasedata['type']}")
      end
    rescue Exception => e
      Chef::Log.warn("could not create database; #{e}")
    end
  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
