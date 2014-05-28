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

# samba (only for dev)
# default['samba']['workgroup'] = 'WORKGROUP'   #- The SMB workgroup to use, default 'SAMBA'.
# default['samba']['interfaces']                #- Interfaces to listen on, default 'lo 127.0.0.1'.
# default['samba']['hosts_allow']               #- Allowed hosts/networks, default '127.0.0.0/8'.
# default['samba']['bind_interfaces_only']      #- Limit interfaces to serve SMB, default 'no'
# default['samba']['server_string']             #- Server string value, default 'Samba Server'.
# default['samba']['load_printers']             #- Whether to load printers, default 'no'.
# default['samba']['passdb_backend']            #- Which password backend to use, default 'tdbsam'.
# default['samba']['dns_proxy']                 #- Whether to search NetBIOS names through DNS, default 'no'.
# default['samba']['security']                  #- Samba security mode, default 'user'.
# default['samba']['map_to_guest']              #- What Samba should do with logins that don't match Unix users, default 'Bad User'.
# default['samba']['socket_options']            #- Socket options, default 'TCP_NODELAY'
# default['samba']['config']                    #- Location of Samba configuration, default '/etc/samba/smb.conf'.
# default['samba']['log_dir']                   #- Location of Samba logs, default '/var/log/samba/%m.log'.


default['samba']['server_string'] = 'zf2'
default['samba']['netbios_name'] = 'zf2'
default['samba']['workgroup'] = 'WORKGROUP'
default['samba']['interfaces'] = '127.0.0.0/8 eth0'
default['samba']['hosts_allow'] = 'ALL'
default['samba']['passdb_backend'] = 'tdbsam'
default['samba']['dns_proxy'] = 'no'
default['samba']['security'] = 'user'
default['samba']['config'] = '/etc/samba/smb.conf'
default['samba']['log_dir'] = '/var/log/samba/%m.log'
default['samba']['load_printers'] = 'no'

