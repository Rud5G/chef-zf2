#
# Cookbook Name:: zf2
# Library:: virtualhost
#
# Copyright (C) 2013 Triple-networks
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

class Chef::Recipe::Virtualhost
  def self.settings(node)
    if Chef::Config[:solo]
      begin
        settings = Chef::DataBagItem.load('virtualhost', 'virtualhost')['local']
      rescue
        Chef::Log.info('No virtualhost data bag found')
      end
    else
      begin
        settings = Chef::EncryptedDataBagItem.load('virtualhost', 'virtualhost')[node.chef_environment]
      rescue
        Chef::Log.info('No virtualhost encrypted data bag found')
      end
    end
    settings ||= node['virtualhost']
  end
end
