#
# Cookbook Name:: zf2
# Recipe:: swap
#
# Copyright (c) 2015 The Authors, All Rights Reserved.



swap_file node['swap']['file'] do
  size node['swap']['size'] # MBs
  persist node['swap']['persist']
end
