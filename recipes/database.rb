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

# Configure the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
  action :install
end

# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Load the secrets file and the encrypted data bag item that holds the root password.
##password_secret = Chef::EncryptedDataBagItem.load_secret(databasedata['passwords']['secret_path'])
##root_password_data_bag_item = Chef::EncryptedDataBagItem.load('passwords', 'sql_server_root_password', password_secret)

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password node['mysql']['server_root_password']
  data_dir '/var/lib/mysql'
  action [:create, :start]
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
          :host => databasedata['host'],
          :port => databasedata['port']
      }

      case databasedata['type']
        when 'mysql'

          database_connection.merge!({
              :host => databasedata['host'],
              :username => 'root',
              :socket   => "/run/mysql-#{defaultmysqlinstance}/mysqld.sock",
              :password => node['mysql']['server_root_password']
          })

          # Create the database instance.
          mysql_database databasedata['dbname'] do
            connection database_connection
            action :create
          end

          # set the secure_passwords
          if databasedata['password'].nil?
            database_bagitem[node.chef_environment]['password'] = secure_password
            database_bagitem.save unless Chef::Config[:solo]
            databasedata['password'] = database_bagitem[node.chef_environment]['password']
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