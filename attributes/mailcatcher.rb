#
# Cookbook Name:: zf2
# Attribute:: mailcatcher
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

# mailcatcher
default['mailcatcher']['bin']                           = '/usr/bin/env PATH=/opt/chef/embedded/bin:"$PATH" catchmail'
default['mailcatcher']['http-ip']                       = '0.0.0.0'
default['mailcatcher']['http-port']                     = 1080
default['mailcatcher']['smtp-ip']                       = '127.0.0.1'
default['mailcatcher']['smtp-port']                     = 1025
default['mailcatcher']['env-enabled']                   = %w(development testing)

