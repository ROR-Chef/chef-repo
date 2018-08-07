#
# Cookbook:: wiki11
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'wiki11::nginx_config'
include_recipe 'wiki11::monit'
