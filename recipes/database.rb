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

db_instance_name = 'default'


# setup mysql service: 'mysql-default'
mysql_service db_instance_name do
  port '3306'
  version '5.5'
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end

# required by mysql-database-setup
mysql2_chef_gem db_instance_name do
  action :install
end


#
begin
  Chef::Log.debug("Cookbook #{cookbook_name} in the recipe: #{recipe_name}.")

  data_bag('databases').each do |database|
    Chef::Log.debug("data_bags/databases/#{database}")

    databasedata = data_bag_item('databases', database)[node.chef_environment]
    Chef::Log.debug(databasedata.inspect)


    # description / steps

    # 0. database provider
    # 1. check database provider: warning if !== MySQL
    # 2. setup connection_info: merge connection_info with node[ database-provider-name ]
    # 4. create database
    # 5. fix some mysql-bug.
    # 6. setup database-user

    begin

      # MySQL, Postgresql, SqlServer
      dbprovider = databasedata['type']

      Chef::Log.fatal('Unsupported database type or invalid data_bag data') unless dbprovider == 'mysql'

      # Externalize conection info in a ruby hash
      mysql_connection_info = {
          :host     => databasedata['host'],
          :port     => databasedata['port'],
          :socket   => "/var/run/mysql-#{db_instance_name}/mysqld.sock",
          :username => 'root',
          :password => node[dbprovider]['server_root_password']
      }

      # Create a mysql database on a named mysql instance
      mysql_database databasedata['dbname'] do
        connection mysql_connection_info
        action :create
      end

      # Grant permissions to the user
      mysql_database_user databasedata['username'] do
        connection    mysql_connection_info
        password      databasedata['password']
        database_name databasedata['dbname']
        host          '%'
        privileges    [:select,:update,:insert,:create,:delete]
        action        :grant
      end

      # # remove possible account for anonmous user.
      # # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
      # mysql_database_user '' do
      #   connection database_connection
      #   host 'localhost'
      #   action :drop
      # end

    rescue Exception => e
      Chef::Log.error("could not create database; #{e}")
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
