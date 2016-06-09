#
# Cookbook Name:: zf2
# Recipe:: servernode
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

include_recipe 'zf2::baseserver'

unless node.chef_environment == 'testing'
  Chef::Log.info(node.chef_environment)
  Chef::Log.info(node.to_hash)
  include_recipe 'zf2::swap'
end

include_recipe 'zf2::database'

include_recipe 'zf2::mysql_logrotate'

include_recipe 'zf2::webserver'

include_recipe 'zf2::php'

include_recipe 'zf2::nodejs'

include_recipe 'zf2::deploy'
