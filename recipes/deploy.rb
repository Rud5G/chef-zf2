#
# Cookbook Name:: zf2
# Recipe:: deploy
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
ssh_wrapper_path = '/var/tmp/chef_ssh_wrapper.sh'
template ssh_wrapper_path do
  source 'chef_ssh_wrapper.sh.erb'
  owner 'root'
  mode 0755
end


#
# deploy 'name' do
#   after_restart              Proc, String
#   before_migrate             Proc, String
#   before_restart             Proc, String
#   before_symlink             Proc, String
#   branch                     String
#   create_dirs_before_symlink Array
#   deploy_to                  String # defaults to 'name' if not specified
#   enable_submodules          TrueClass, FalseClass
#   environment                Hash
#   git_ssh_wrapper            String
#   group                      String
#   keep_releases              Integer
#   migrate                    TrueClass, FalseClass
#   migration_command          String
#   notifies                   # see description
#   provider                   Chef::Provider::Deploy
#   purge_before_symlink       Array
#   remote                     String
#   repo                       String
#   repository                 String
#   repository_cache           String
#   restart_command            Proc, String
#   revision                   String
#   rollback_on_error          TrueClass, FalseClass
#   scm_provider               Chef::Provider::Git
#   shallow_clone              TrueClass, FalseClass
#   ssh_wrapper                String
#   symlinks                   Hash
#   symlink_before_migrate     Hash
#   timeout                    Integer
#   user                       String
#   action                     Symbol # defaults to :create if not specified
# end




begin
  data_bag('projects').each do |project|
    projectdata = data_bag_item('projects', project)

    begin
      parentprojectdir = Pathname.new(projectdata['projectdir']).parent

      # create parentprojectdir
      directory parentprojectdir.to_path do
        mode 00775
        action :create
        recursive true
      end

      # database databag id
      if projectdata['db_databag_id']
        databasedata = data_bag_item('databases', projectdata['db_databag_id'])[node.chef_environment]
        Chef::Log.info('databasedata.inspect')
        Chef::Log.info(databasedata.inspect)
      end

      Chef::Log.info('start inspect')
      Chef::Log.info(projectdata.inspect)
      Chef::Log.info(projectdata['remove_recursive_from_shared'].inspect)

      # execute database migrations
      if projectdata['db_migration'] === true
        migrationcmd = 'php public/index.php migration apply'
      else
        migrationcmd = projectdata['db_migration']
      end

      # start deploy resource
      deploy projectdata['projectdir'] do
        branch projectdata['revision']
        deploy_to projectdata['projectdir']
        environment 'APP_ENV' => node.chef_environment, 'RAILS_ENV' => node.chef_environment, 'XDG_CONFIG_HOME' => File.join('/home', projectdata['owner'])
        git_ssh_wrapper ssh_wrapper_path
        keep_releases projectdata['depth'] || 5
        migrate false # projectdata.has_key?('db_migration')
        provider provider Chef::Provider::Deploy::Workstation
        # provider Chef::Provider::Deploy::Workstation
        repository projectdata['repository']
        rollback_on_error false
        scm_provider Chef::Provider::Git
        shallow_clone true
        user projectdata['owner']
        group projectdata['group']
        action :deploy

        # about the callbacks and migrate, symlink, etc. functionality.
        # this is the exact order:
        #
        #   :before_migrate
        #   migrate
        #   :before_symlink
        #   symlink
        #   :before_restart
        #   restart
        #   :after_restart
        #   cleanup!
        #
        #

        # symlinks and directories: in this order
        create_dirs_before_symlink projectdata['create_dirs_before_symlink']
        purge_before_symlink projectdata['purge_before_symlink']
        # this is being done seperate (see below)
        symlink_before_migrate({})
        symlinks projectdata['symlinks']

        ## BEFORE_MIGRATE
        before_migrate do

          Chef::Log.info('before_migrate')

          # right order:
          #   - create symlinks (outward)
          #   - composer install
          #   - database migrations


          # set local var?
          project_shared_path = shared_path

          # release_path is the path to the timestamp dir
          # set local var
          current_release = release_path

          # A local variable with the deploy resource.
          deploy_resource = new_resource


          # add writeable directories
          projectdata['create_dirs_before_symlink'].each do |created_dir|
            path = File.join(project_shared_path, created_dir)
            directory path do
              group projectdata['group']
              mode 00755
              owner projectdata['owner']
              recursive false
              action :create
            end
          end if projectdata['create_dirs_before_symlink']

          # add writeable directories
          projectdata['writabledirs'].each do |writabledir|
            path = File.join(project_shared_path, writabledir)
            directory path do
              group 'www-data'
              mode 02777
              owner projectdata['owner']
              recursive false
              action :create
            end
          end if projectdata['writabledirs']


          if projectdata['remove_recursive_from_shared'].nil?
            Chef::Log.info("remove_recursive_from_shared is nil")
          end

          unless projectdata['remove_recursive_from_shared'].nil?
            log_info = projectdata['remove_recursive_from_shared'].join(", ")
            projectdata['remove_recursive_from_shared'].each do |dir|
              FileUtils.rm_rf(File.join(project_shared_path, dir))
            end
            Chef::Log.info("in #{project_shared_path} purged directories: #{log_info}")
          end



          Chef::Log.info('symnlink inspection')


          # make sure that the symlinks source can be saved (create the parent directory) in the shared root.
          projectdata['symlink_before_migrate'].each do |path_dir_or_file, symlink|
            abs_parent_path = Pathname.new(File.expand_path(path_dir_or_file, project_shared_path)).parent.to_path
            # Chef::Log.debug("symlink: #{symlink} has the abs parent: #{abs_parent_path}")
            Chef::Log.info("symlink: #{symlink} has the abs parent: #{abs_parent_path}")
            create_dir_unless_exists(abs_parent_path)
          end

          # make sure that the database config file is linked
          projectdata['symlink_before_migrate'].each do |path_dir_or_file, symlink|
            linkfrom = File.join(current_release, path_dir_or_file)
            linkto = File.join(project_shared_path, symlink)
            link linkfrom do
              to linkto
              link_type :symbolic
            end
          end


          projectdata['symlinks'].each do |path_dir_or_file, symlink|
            abs_parent_path = Pathname.new(File.expand_path(path_dir_or_file, project_shared_path)).parent.to_path
            Chef::Log.debug("symlink: #{symlink} has the abs parent: #{abs_parent_path}")
            create_dir_unless_exists(abs_parent_path)
          end



          # composer install should before_migrate (before_symlink is too late)
          # install composer.phar in project_shared_path
          bash 'composer_installer' do
            cwd project_shared_path
            environment 'COMPOSER_HOME' => File.join('/home', projectdata['owner'], '.composer')
            user projectdata['owner']
            code <<-EOH
              php -r "readfile('https://getcomposer.org/installer');" | php
            EOH
            creates File.join(project_shared_path, 'composer.phar')
          end if projectdata['use_composer']

          link "#{current_release}/composer.phar" do
            to "#{project_shared_path}/composer.phar"
          end

          github_oauth = projectdata['github-oauth'] || ''

          # use the symlink of the composer.phar
          # composer install (uses: .lock file)
          bash 'install_composer' do
            # cwd projectdata['projectdir']
            cwd current_release
            # should be better than hardcoded /home/user, but its still better then /root/user (issue chef-bash resource? )
            environment 'COMPOSER_HOME' => File.join('/home', projectdata['owner'], '.composer'), 'GITHUB_OAUTH' => github_oauth
            user projectdata['owner']
            code <<-EOH
              php composer.phar selfupdate -vvv
              if [[ -n "$GITHUB_OAUTH" ]]; then
                  php composer.phar config -g "github-oauth.github.com" "$GITHUB_OAUTH"
              fi
              php composer.phar install -vvv
            EOH
          end if projectdata['use_composer']


          Chef::Log.info('template for the database config file')
          Chef::Log.info(File.join(project_shared_path, projectdata['database_settings_file']).inspect)

          # database databag id
          if projectdata['db_databag_id']
            deploy_databasedata = databasedata
            template File.join(project_shared_path, projectdata['database_settings_file']) do
              source projectdata['database_template']
              cookbook projectdata['cookbook_name'] || cookbook_name.to_s
              owner projectdata['owner']
              group projectdata['group']
              mode 0644
              sensitive true
              variables ({
                  :database => deploy_databasedata
              })
            end
          end

          bash 'db_migrations' do
            user projectdata['owner']
            cwd current_release
            code <<-EOH
              #{migrationcmd}
            EOH
          end if projectdata['db_migration']

        end


        ## BEFORE_SYMLINK
        before_symlink do

          # not so much here at the moment.
          Chef::Log.info('before_symlink')

        end

      end

    rescue Exception => e
      Chef::Log.warn("Could create project, exception; #{e}")
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
