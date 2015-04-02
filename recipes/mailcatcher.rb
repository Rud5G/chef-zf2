#
# Cookbook Name:: zf2
# Recipe:: mailcatcher
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

# Never enable on production
unless node.chef_environment == 'production'

  # This is a dependency of MailCatcher
  case node['platform_family']
    when 'debian'
      package 'sqlite'
      package 'libsqlite3-dev'
    when 'rhel', 'fedora', 'suse'
      package 'libsqlite3-dev'
    else
      # type code here
      Chef::Log.warn('Unsupported platform_family: '+ node['platform_family'])
  end

  # Install MailCatcher
  gem_package 'mailcatcher'

  # Generate the startmailcatchcommand
  startmailcatchcommand = sprintf('mailcatcher --http-ip %s --http-port %s --smtp-ip %s --smtp-port %s', node['mailcatcher']['http-ip'], node['mailcatcher']['http-port'], node['mailcatcher']['smtp-ip'], node['mailcatcher']['smtp-port'])

  Chef::Log.info("start mailcatch command = #{startmailcatchcommand}")

  # Start MailCatcher
  bash 'mailcatcher' do
    not_if 'ps ax | grep -E "mailcatche[r]"'
    code startmailcatchcommand
  end

  # Publish PHP configuration
  template File.join(node['php']['ext_conf_dir'], 'mailcatcher.ini') do
    source 'mailcatcher.ini.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end


  bash 'php5enmod_mailcatcher' do
    code 'php5enmod mailcatcher'
    only_if { ::File.exists?(node['php']['php5enmod']) }
  end

end
