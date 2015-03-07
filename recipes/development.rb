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

  # users check
  include_recipe 'baseserver::users'

  # git
  package 'git-flow'

  # git config
  # git config --global color.ui true
  # git config --global core.editor vim
  # git config --global user.name "Your Name"
  # git config --global user.email you@example.com

  # phpmyadmin
  package 'phpmyadmin'


  # samba prep.
  chef_gem 'chef-rewind'
  require 'chef/rewind'

  # determine the cookbook of the template.
  template_cookbook = node['samba']['template_cookbook']
  template_cookbook ||= cookbook_name.to_s

  # samba server
  include_recipe 'samba::server'
  # smb.conf.erb located inside <template_cookbook> /templates/default/smb.conf.erb
  rewind 'template[/etc/samba/smb.conf]' do
    source 'smb.conf.erb'
    cookbook_name template_cookbook
  end

  # samba client
  include_recipe 'samba::default'

  # mailcatcher
  include_recipe 'zf2::mailcatcher'

end
