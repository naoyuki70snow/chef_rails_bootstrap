#
# Cookbook Name:: rails-env
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'ruby-env'

%w{libxml2-devel libxslt-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{nokogiri}.each do |gem|
  execute "gem install #{gem}" do
    command "/home/#{node['rails-env']['user']}/.rbenv/shims/gem install #{gem} -- --use-system-libraries=true --with-xml2-include=/usr/include/libxml2/"
    user node['rails-env']['user']
    group node['rails-env']['group']
    environment 'HOME' => "/home/#{node['rails-env']['user']}"
    creates "/home/#{node['rails-env']['user']}/.rbenv/shims/#{gem}"
  end
end

%w{rails}.each do |gem|
  execute "gem install #{gem}" do
    command "/home/#{node['rails-env']['user']}/.rbenv/shims/gem install #{gem}"
    user node['rails-env']['user']
    group node['rails-env']['group']
    environment 'HOME' => "/home/#{node['rails-env']['user']}"
    creates "/home/#{node['rails-env']['user']}/.rbenv/shims/#{gem}"
  end
end

execute "rails new #{node['rails-env']['project']}" do
  command "/home/#{node['rails-env']['user']}/.rbenv/shims/rails new #{node['rails-env']['project']} --skip-bundle"
  cwd "/home/#{node['rails-env']['user']}"
  user node['rails-env']['user']
  group node['rails-env']['group']
  environment 'HOME' => "/home/#{node['rails-env']['user']}"
  creates "/home/#{node['rails-env']['user']}/#{node['rails-env']['project']}"
end

%w{shared shared/pids shared/log}.each do |dir|
  directory "/home/#{node['rails-env']['user']}/#{node['rails-env']['project']}/#{dir}" do
    owner node['rails-env']['user']
    group node['rails-env']['group']
    mode 00775
    action :create
  end
end
   
cookbook_file "/home/#{node['rails-env']['user']}/#{node['rails-env']['project']}/Gemfile" do
  mode 00664
end

cookbook_file "/home/#{node['rails-env']['user']}/#{node['rails-env']['project']}/config/unicorn.rb" do
  mode 00664
end


execute "bundle install" do
  command "/home/#{node['rails-env']['user']}/.rbenv/shims/bundle install"
  cwd "/home/#{node['rails-env']['user']}/#{node['rails-env']['project']}"
  user node['rails-env']['user']
  group node['rails-env']['group']
  environment 'HOME' => "/home/#{node['rails-env']['user']}"
  creates "/home/#{node['rails-env']['user']}/#{node['rails-env']['project']}/Gemfile.lock"
end
=begin
execute "unicorn down" do
  command "kill -QUIT `cat /home/#{node['rails-env']['user']}/#{node['rails-env']['project']}/shared/pids/unicorn.pid`"
  user node['rails-env']['user']
  group node['rails-env']['group']
  environment 'HOME' => "/home/#{node['rails-env']['user']}"
  only_if "ps aux | grep unicorn | grep -v grep"
end
=end
execute "unicorn up" do
  command "/home/#{node['rails-env']['user']}/.rbenv/shims/unicorn -c config/unicorn.rb -D"
  cwd "/home/#{node['rails-env']['user']}/#{node['rails-env']['project']}"
  user node['rails-env']['user']
  group node['rails-env']['group']
  environment 'HOME' => "/home/#{node['rails-env']['user']}"
  not_if "ps aux | grep unicorn | grep -v grep"
end
