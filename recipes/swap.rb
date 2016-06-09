#
# Cookbook Name:: zf2
# Recipe:: swap
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

swap_file '/mnt/swap' do
  size 1024 # MBs
  persist true
end
