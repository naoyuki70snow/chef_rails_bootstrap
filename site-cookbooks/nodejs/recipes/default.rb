#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{gcc-c++}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "/tmp/#{node['nodejs']['filename']}" do
  source "#{node['nodejs']['remote_url']}"
  not_if "ls -l /usr/local/bin/ | grep node"
end

bash "install nodejs" do
  user "root"
  cwd "/tmp"
  code <<-EOC
    tar zxvf #{node['nodejs']['filename']}
    cd #{node['nodejs']['dirname']}
    make
    make install
  EOC
  not_if "ls -l /usr/local/bin/ | grep node"
end
