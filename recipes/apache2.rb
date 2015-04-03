#
# Cookbook Name:: zf2
# Recipe:: apache
#
# Copyright (C) 2013 Triple-networks
# 
# All rights reserved - Do Not Redistribute
#

# make sure for PHP we dont have the mpm_event mod
# save to node here and set override in the attributes/apache2
node.set['apache2']['mpm'] = 'prefork'
node.save unless Chef::Config[:solo]

include_recipe 'apache2::default'

# this should not be required anymore.
# include_recipe 'apache2::mpm_prefork'


begin
  data_bag('virtualhosts').each do |virtualhost|
    hostdata = data_bag_item('virtualhosts', virtualhost)[node.chef_environment]

    if hostdata['create_docroot']
      directory hostdata['docroot'] do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
      end
    end
    
    # set default template
    hosttemplate = hostdata['template']
    hosttemplate ||= 'web_app.conf.erb'
    hostcookbook = hostdata['cookbook']
    hostcookbook ||= cookbook_name.to_s

    #webappname = '000-'+hostdata['id']
    
    web_app hostdata['server_name'] do
      enable hostdata['enable']
      server_name hostdata['server_name']
      server_aliases hostdata['server_aliases']
      template hosttemplate
      cookbook hostcookbook
      docroot hostdata['docroot']
      allow_override hostdata['allow_override']
      directory_options hostdata['directory_options']
      directory_index hostdata['directory_index']
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
