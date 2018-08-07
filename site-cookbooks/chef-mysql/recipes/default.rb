#
# Cookbook:: chef-mysql
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password 'neerajku09'
  action [:create, :restart]
end

mysql_client 'default' do
  action :create
end
