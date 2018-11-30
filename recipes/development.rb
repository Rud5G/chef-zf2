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

  # debconf
  package 'debconf' do
    response_file 'debconf.seed'
  end

  # phpmyadmin
  package 'phpmyadmin'


  shares = data_bag_item(node['samba']['shares_data_bag'], 'shares')
  shares['shares'].each do |k, v|
    samba_share k do
      comment v['comment']
      path v['path'] # String for the path of directory to be served. Required.
      guest_ok v['guest ok'] # yes, no
      valid_users v['valid users'].join(' ') # space separated users or group, default ''
      write_list v['valid users'] # An array of Unix users
      create_mask v['create mask'] # e.g. 0644
      directory_mask v['directory mask'] # e.g. 0700
    end
  end

  users = if node["samba"]["passdb_backend"] !=~ /^ldapsam/ && node['samba']['find_users_from_data_bag'] == true
    search(node['samba']['users_data_bag'], '*:*') # ~FC003
  end
  if users
    users.each do |u|
      next unless u['smbpasswd']
      samba_user u['id'] do
        password u['smbpasswd']
        shell '/bin/bash'
        comment 'chef managed home'
        manage_home true
        action [:create, :enable]
      end
    end
  end

  samba_server 'samba server' do
    workgroup node['samba']['workgroup'] # The SMB workgroup to use, default "SAMBA".
    interfaces node['samba']['interfaces'] # Interfaces to listen on, default "lo 127.0.0.1".
    hosts_allow node['samba']['hosts_allow'] # Allowed hosts/networks, default "127.0.0.0/8".
    bind_interfaces_only node['samba']['bind_interfaces_only'] # Limit interfaces to serve SMB, default "no"
    load_printers node['samba']['load_printers'] # Whether to load printers, default "no".
    passdb_backend node['samba']['passdb_backend'] # Which password backend to use, default "tdbsam".
    dns_proxy node['samba']['dns_proxy'] # Whether to search NetBIOS names through DNS, default "no".
    security node['samba']['security'] # Samba security mode, default "user".
    map_to_guest node['samba']['map_to_guest'] # What Samba should do with logins that don't match Unix users, default "Bad User".
    socket_options node['samba']['socket_options'] # Socket options, default "`TCP_NODELAY`"
    # config_file # Location of Samba configuration, see resource for platform default
    # log_dir # Location of Samba logs, see resource for platform default
    # realm # Kerberos realm to use, default: ''
    # password_server # Use a specific remote server for auth, default: ''
    # encrypt_passwords # Whether to negotiate encrypted passwords, default: yes
    # kerberos_method # How kerberos tickets are verified, default: secrets only
    # log_level # Sets the logging level from 0-10, default: 0
    # winbind_separator # Define the character used when listing a username of the form of DOMAIN \user, default \
    # idmap_config # Define the mapping between SIDS and Unix users and groups, default: none
    # max_log_size # Maximum log file size, default: 5000, (5MB)
    # options # list of additional options, e.g. 'unix charset' => 'UTF8'.
  end

  # samba client
  # include_recipe 'samba'

  # mailcatcher
  include_recipe 'zf2::mailcatcher'

end
