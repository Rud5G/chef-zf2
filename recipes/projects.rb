#
# Cookbook Name:: zf2
# Recipe:: projects
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

# set ssh_wrapper from template
template '/var/tmp/chef_ssh_wrapper.sh' do
  source 'chef_ssh_wrapper.sh.erb'
  owner 'root'
  mode 0755
end

begin
  data_bag('projects').each do |project|
    projectdata = data_bag_item('projects', project)

    begin
      Chef::Log.debug(projectdata.inspect)
      Chef::Log.debug("Cookbook #{cookbook_name} in the recipe: #{recipe_name}.")

      parentprojectdir = Pathname.new(projectdata['projectdir']).parent

      # create parentprojectdir
      directory parentprojectdir.to_path do
        mode 00775
        action :create
        recursive true
      end

      # clone repository
      git projectdata['projectdir'] do
        repository projectdata['repository']
        checkout_branch projectdata['checkout_branch']
        revision projectdata['revision']
        action :sync
        user projectdata['owner']
        group projectdata['group']
        ssh_wrapper '/var/tmp/chef_ssh_wrapper.sh'
      end

      # create directories if they do not exist
      projectdata['createdirs'].each do |createdir|
        path = File.join(projectdata['projectdir'], createdir)
        # Chef::Log.info("writabledir: #{path}")
        directory path do
          group projectdata['group']
          # mode 02777
          owner projectdata['owner']
          recursive false
          action :create
        end unless File.directory?(path)
      end if projectdata['createdirs']

      # add writeable directories
      projectdata['writabledirs'].each do |writabledir|
        path = File.join(projectdata['projectdir'], writabledir)
        # Chef::Log.info("writabledir: #{path}")
        directory path do
          group 'www-data'
          mode 02777
          owner projectdata['owner']
          recursive false
          action :create
        end
      end if projectdata['writabledirs']

      # install composer.phar
      bash 'composer_installer' do
        environment 'COMPOSER_HOME' => parentprojectdir.to_path
        user projectdata['owner']
        cwd projectdata['projectdir']
        code <<-EOH
          curl -sS https://getcomposer.org/installer | php
        EOH
        creates File.join(projectdata['projectdir'], 'composer.phar')
      end if projectdata['use_composer']

      # composer install (uses: .lock file)
      bash 'install_composer' do
        environment 'COMPOSER_HOME' => parentprojectdir.to_path
        user projectdata['owner']
        cwd projectdata['projectdir']
        code <<-EOH
          php composer.phar selfupdate
          php composer.phar install
        EOH
      end if projectdata['use_composer']

      # database databag id
      if projectdata['db_databag_id']
        databasedata = data_bag_item('databases', projectdata['db_databag_id'])[node.chef_environment]

        cookbookname = projectdata['cookbook_name'] || cookbook_name.to_s

        template File.join(projectdata['projectdir'], projectdata['database_settings_file']) do
          source projectdata['database_template']
          cookbook cookbookname
          owner projectdata['owner']
          group projectdata['group']
          mode 0644
          variables(
              :database => databasedata
          )
        end
      end

      # execute database migrations
      if projectdata['db_migration'] === true
        migrationcmd = 'php public/index.php migration apply'
      else
        migrationcmd = projectdata['db_migration']
      end

      bash 'db_migrations' do
        user projectdata['owner']
        cwd projectdata['projectdir']
        code <<-EOH
          #{migrationcmd}
        EOH
      end if projectdata['db_migration']

    rescue Exception => e
      Chef::Log.warn("Could create project, exception; #{e}")
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
