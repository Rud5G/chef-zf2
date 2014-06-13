#
# Cookbook Name:: zf2
# Recipe:: apache
#
# Copyright (C) 2013 Triple-networks
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'apache2'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_php5'
include_recipe 'apache2::mod_rewrite'

begin
  data_bag('virtualhosts').each do |virtualhost|
    hostdata = data_bag_item('virtualhosts', virtualhost)

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

    #webappname = '000-'+hostdata['id']
    
    web_app hostdata['id'] do
      enable hostdata['enable']
      server_name hostdata['server_name']
      server_aliases hostdata['server_aliases']
      template hosttemplate
      # cookbook hostdata['cookbook'] if hostdata['cookbook']
      docroot hostdata['docroot']
      allow_override hostdata['allow_override']
      directory_options hostdata['directory_options']
      directory_index hostdata['directory_index']
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
