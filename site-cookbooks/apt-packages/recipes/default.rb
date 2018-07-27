#
# Cookbook:: apt-packages
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'libgmp3-dev' do
  action :install
end

package 'jpegoptim' do
  action :install
end

package 'imagemagick' do
  action :install
end

package 'libmagickwand-dev' do
  action :install
end
