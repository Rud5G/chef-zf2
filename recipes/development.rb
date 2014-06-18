#
# Cookbook Name:: zf2
# Recipe:: development
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

if node.chef_environment == 'development'

  package 'git-flow'
  package 'phpmyadmin'

  # git config
  # git config --global color.ui true
  # git config --global core.editor vim
  # git config --global user.name "Your Name"
  # git config --global user.email you@example.com

  # users
  include_recipe 'baseserver::users'

  chef_gem 'chef-rewind'
  require 'chef/rewind'

  # see
  include_recipe 'samba::server'
  # smb.conf.erb located inside zf2/templates/default/smb.conf.erb
  rewind :template => '/etc/samba/smb.conf' do
    source 'smb.conf.erb'
    cookbook_name 'zf2'
  end

  # samba
  include_recipe 'samba::default'

  # nodejs for grunt
  include_recipe 'nodejs'

  bash 'install-grunt-simple' do
    code <<-EOH
      npm install -g grunt-cli
    EOH
  end

  include_recipe 'zf2::mailcatcher'

end
