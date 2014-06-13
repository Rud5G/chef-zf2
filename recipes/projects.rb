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
#
#
# Chef::Log.info(node['parent'])
# Chef::Log.info(Chef::Config.inspect)
# Chef::Log.info(node.inspect)

Chef::Log.info(loaded_recipes.inspect)

# Get the Chef::CookbookVersion for the current cookbook
cb = run_context.cookbook_collection[cookbook_name]

Chef::Log.info(cb.inspect)


# Loop over the array of files.
# 'templates' will also work.
cb.manifest['templates'].each do |cookbookfile|
  Chef::Log.info("found: " + cookbookfile['name'])
end


Chef::Log.info("RECIPE_NAME: #{recipe_name}, COOKBOOK_NAME: #{cookbook_name}")




Chef::Log.info(run_context.cookbook_collection[cookbook_name].inspect)



Chef::Log.info(:cookbook_name)


begin
  data_bag('projects').each do |project|
    projectdata = data_bag_item('projects', project)

    begin
      Chef::Log.debug(projectdata.inspect)

      parentprojectdir = Pathname.new(projectdata['projectdir']).parent

      # create parentprojectdir
      directory parentprojectdir.to_path do
        owner projectdata['owner']
        group projectdata['group']
        mode 00775
        action :create
        recursive true
      end

      # # set ssh_wrapper from template
      # template '/var/tmp/chef_ssh_wrapper.sh' do
      #   source 'chef_ssh_wrapper.sh.erb'
      #   owner 'root'
      #   mode 0755
      # end

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
        user projectdata['owner']
        cwd projectdata['projectdir']
        code <<-EOH
          curl -sS https://getcomposer.org/installer | php
        EOH
        creates File.join(projectdata['projectdir'], 'composer.phar')
      end if projectdata['use_composer']

      # composer install (uses: .lock file)
      bash 'install_composer' do
        user projectdata['owner']
        cwd projectdata['projectdir']
        code <<-EOH
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
      bash 'db_migrations' do
        user projectdata['owner']
        cwd projectdata['projectdir']
        code <<-EOH
          php public/index.php migration apply
        EOH
      end if projectdata['db_migration']

    rescue Exception => e
      Chef::Log.warn("Could create project, exception; #{e}")
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
