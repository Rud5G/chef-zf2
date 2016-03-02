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

default['samba']['server_string'] = 'zf2'
default['samba']['netbios_name'] = 'zf2'

# windows support
default['samba']['support_windows_clients'] = true

# template cookbook (nil is the cookbook with the recipe)
default['samba']['template_cookbook'] = nil # default: nil

# development

# global config
default['samba']['workgroup']             = 'WORKGROUP'
default['samba']['interfaces']            = '127.0.0.0/8 eth0 eth1'
default['samba']['bind_interfaces_only']  = 'no'
default['samba']['hosts_allow']           = 'ALL'
default['samba']['load_printers']         = 'no'
default['samba']['passdb_backend']        = 'tdbsam'
default['samba']['enable_users_search']   = true
default['samba']['dns_proxy']             = 'no'
default['samba']['security']              = 'user'
default['samba']['map_to_guest']          = 'Never'
default['samba']['socket_options']        = 'TCP_NODELAY IPTOS_LOWDELAY SO_KEEPALIVE SO_SNDBUF=8192'
default['samba']['shares_data_bag']       = 'samba'
default['samba']['users_data_bag']        = 'users'

# prevent printing error in the logs
default['samba']['printing'] = 'bsd'
default['samba']['printcap_name'] = '/dev/null'

# configure follow symlinks
default['samba']['follow_symlinks'] = 'yes'
default['samba']['allow_insecure_wide_links'] = 'yes'
default['samba']['wide_links'] = 'yes'
default['samba']['unix_extensions'] = 'yes'

# 'Configure Options'-documentation
#
# https://www.samba.org/samba/docs/using_samba/appb.html
# cache:https://www.samba.org/samba/docs/using_samba/appb.html
default['samba']['case_sensitive'] = 'yes'

# windows support settings
if node['samba']['support_windows_clients']
  default['samba']['nt_acl_support'] = 'yes'
  default['samba']['hide_dot_files'] = 'yes'
  default['samba']['map_archive'] = 'yes'
  default['samba']['map_hidden'] = 'no'
  default['samba']['map_system'] = 'no'
else
  # fix (read: kill) windows
  default['samba']['nt_acl_support'] = 'no'
  default['samba']['hide_dot_files'] = 'no'
  default['samba']['map_archive'] = 'no'
  default['samba']['map_hidden'] = 'no'
  default['samba']['map_system'] = 'no'
end
