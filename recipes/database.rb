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

begin
  data_bag('databases').each do |database|
    databasedata = data_bag_item('databases', database)[node.chef_environment]

    Chef::Log.debug(databasedata.inspect)
    Chef::Log.debug("Cookbook #{cookbook_name} in the recipe: #{recipe_name}.")


    begin
      database_connection = {
          :host => databasedata['host'],
          :port => databasedata['port']
      }

      case databasedata['type']
        when 'mysql'
          include_recipe 'mysql::server'
          include_recipe 'database::mysql'
          database_connection.merge!({ :username => 'root', :password => node['mysql']['server_root_password'] })

          mysql_database databasedata['dbname'] do
            connection database_connection
            collation 'utf8_bin'
            encoding 'utf8'
            action :create
          end

          # remove possible account for anonmous user.
          # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
          mysql_database_user '' do
            connection database_connection
            host 'localhost'
            action :drop
          end

          mysql_database_user databasedata['username'] do
            connection database_connection
            host '%'
            password databasedata['password']
            database_name databasedata['dbname']
            action [:create, :grant]
          end
        else
          Chef::Log.warn('Unsupported database type.')
      end

    rescue Exception => e
      Chef::Log.warn("could not create database; #{e}")
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
