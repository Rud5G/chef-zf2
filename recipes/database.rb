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

if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
  servicemanagername = 'systemd'
else
  servicemanagername = 'auto'
end

# Configure the MySQL service.
mysql_service 'default' do
  # version node['mysql']['version']
  bind_address '0.0.0.0'
  port '3306'
  initial_root_password node['mysql']['server_root_password']
  # provider MysqlCookbook::MysqlServiceManagerSystemd
  service_manager servicemanagername
  action [:create, :start]
end


# Configure the MySQL client.
mysql_client 'default' do
  # version node['mysql']['version']
  action :create
end

Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

# dont create multiple password for the same user
userswithnewpassword = Hash.new

# Configure databases
begin
  data_bag('databases').each do |database|
    database_bagitem = data_bag_item('databases', database)
    databasedata = database_bagitem[node.chef_environment]

    begin
      database_connection = {
          :port => databasedata['port']
      }

      case databasedata['type']
        when 'mysql'

          database_connection.merge!({
            :host => databasedata['host'],
            :port => databasedata['port'],
            :username => 'root',
            :password => node['mysql']['server_root_password']
          })

          Chef::Log.info("DatabaseRecipe #{recipe_name} in the cookbook #{cookbook_name}.")
          Chef::Log.info(databasedata.to_hash)


          # set the secure_passwords
          if databasedata['password'].nil?
            begin
              if userswithnewpassword.has_key?(databasedata['username'])
                new_db_password = userswithnewpassword[databasedata['username']]
                Chef::Log.info("database user #{databasedata['username']} for #{databasedata['dbname']} set")
              else
                new_db_password = random_password
                userswithnewpassword[databasedata['username']] = new_db_password
                Chef::Log.info("database password #{databasedata['username']} for #{databasedata['dbname']} set")
              end
              database_bagitem[node.chef_environment]['password'] = new_db_password
              database_bagitem.save
              databasedata['password'] = new_db_password
            rescue Exception => e
              Chef::Log.warn("could not save the password in the node; #{e.message}")
              Chef::Log.warn(e.backtrace.inspect)
            end
          end

          begin
            # Create the database instance.
            mysql_database databasedata['dbname'] do
              connection database_connection
              action :create
            end
          rescue Exception => e
            Chef::Log.warn("could not create database; #{e.message}")
            Chef::Log.warn(e.backtrace.inspect)
          end

          begin
            # Add a database user.
            mysql_database_user databasedata['username'] do
              connection database_connection
              password databasedata['password']
              database_name databasedata['dbname']
              host '%'
              action [:create, :grant]
            end
          rescue Exception => e
            Chef::Log.warn("could not set database user; #{e.message}")
            Chef::Log.warn(e.backtrace.inspect)
          end


        else
          # this is now a feature
          Chef::Log.info("Unmanaged database type: #{databasedata['type']}")
      end
    rescue Exception => e
      Chef::Log.warn("database issue: #{e.message}")
      Chef::Log.warn(e.backtrace.inspect)
    end
  end
rescue Net::HTTPServerException => e
  Chef::Log.warn("could not load data bag; #{e.message}")
  Chef::Application.fatal!(e.backtrace.inspect)
end

