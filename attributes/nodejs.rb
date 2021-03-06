#
# Cookbook Name:: zf2
# Attribute:: nodejs
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


#node['nodejs']['install_method'] = 'package'

# find the latest stable version: http://nodejs.org/dist/latest/
#default['nodejs']['install_method'] = 'binary'
#default['nodejs']['version'] = '4.5.0'
#default['nodejs']['binary']['checksum'] = '5678ad94ee35e40fc3a2c545e136a0dc946ac4c039fca5898e1ea51ecf9e7c39'

# default['nodejs']['version'] = '6.2.0'

# default['nodejs']['version'] = '5.9.0'

default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '8.9.1'
default['nodejs']['binary']['checksum']['linux_x64'] = '0e49da19cdf4c89b52656e858346775af21f1953c308efbc803b665d6069c15c'

