#
# Cookbook Name:: zf2
# Attribute:: default
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

# global config

default['samba']['workgroup']             = 'WORKGROUP'
default['samba']['interfaces']            = 'lo 127.0.0.1'
default['samba']['hosts_allow']           = '127.0.0.0/8'
default['samba']['bind_interfaces_only']  = 'no'
default['samba']['server_string']         = Chef::Config[:node_name] + ' samba server'
# 'Samba VM Server: ' + cookbook_name.to_s
default['samba']['load_printers']         = 'no'
default['samba']['passdb_backend']        = 'tdbsam'
default["samba"]['enable_users_search']   = true
default['samba']['dns_proxy']             = 'no'
default['samba']['security']              = 'user'
default['samba']['map_to_guest']          = 'Never'
default['samba']['socket_options']        = 'TCP_NODELAY IPTOS_LOWDELAY SO_KEEPALIVE SO_SNDBUF=8192'
default['samba']['shares_data_bag']       = 'samba'
default['samba']['users_data_bag']        = 'users'

# not standard in samba cookbook
default['samba']['netbios_name'] = 'zf2'

# prevent printing error in the logs
default['samba']['printing'] = 'bsd'
default['samba']['printcap name'] = '/dev/null'

# configure follow symlinks
default['samba']['follow_symlinks'] = 'yes'
default['samba']['wide_links'] = 'yes'
default['samba']['unix_extensions'] = 'yes'

# windows support
default['samba']['case_sensitive'] = 'yes'
default['samba']['hide_dot_files'] = 'no'
default['samba']['map_archive'] = 'no'
default['samba']['map_hidden'] = 'no'
default['samba']['map_system'] = 'no'

# fix (read: kill) windows
default['samba']['nt_acl_support'] = 'no'

# template cookbook (nil is the cookbook with the recipe)
default['samba']['template_cookbook'] = nil # 'zf2'