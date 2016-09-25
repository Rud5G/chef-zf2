#
# Cookbook Name:: zf2
# Attribute:: apache2
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


default['apache']['contact'] = node['application']['admin']['email']

default['apache']['default_site_enabled'] = false

default['apache']['default_modules'] = %w[
  status alias auth_basic autoindex
  dir env mime negotiation setenvif
  mod_deflate mod_expires mod_headers mod_rewrite
]

# custom
default['apache']['canonical_host'] = false

default['apache']['mod_php5']['install_method'] = false

# apache2 cookbook 2.0.0 has bugs around changing the mpm and then attempting a graceful restart
# which fails and leaves the service down.
case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 14.04
      force_override['apache']['mpm'] = 'prefork'
    end
end
