#
# Cookbook Name:: zf2
# Recipe:: apache
#
# Copyright (C) 2013 Triple-networks
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apache2::default'

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
    # hosttemplate = hostdata['template']
    # hosttemplate ||= 'web_app.conf.erb'
    # hostcookbook = hostdata['cookbook']
    # hostcookbook ||= cookbook_name.to_s

    # set default template
    hostdata['template'] ||= 'web_app.conf.erb'
    # set default cookbook
    hostdata['cookbook'] ||= cookbook_name.to_s
    # set default server port
    hostdata['server_port'] ||= 80

    web_app hostdata['server_name'] do
      enable hostdata['enable']
      server_name hostdata['server_name']
      server_aliases hostdata['server_aliases']
      template hostdata['template']
      cookbook hostdata['cookbook']
      docroot hostdata['docroot']
      allow_override hostdata['allow_override']
      directory_options hostdata['directory_options']
      directory_index hostdata['directory_index']
      server_port hostdata['server_port']
    end

  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!("could not load data bag; #{e}")
end
