#
# Cookbook Name:: jst
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "backup localtime" do
  command 'cp /etc/localtime /etc/localtime.back'
  action :run
  notifies :run, "execute[change localtime jst]", :immediately
  creates "/etc/localtime.back"
end

execute "change localtime jst" do
  command 'cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime'
  action :nothing
end

execute "backup /etc/sysconfig/clock" do
  command 'cp /etc/sysconfig/clock /etc/sysconfig/clock.back'
  action :run
  notifies :create, "template[/etc/sysconfig/clock]", :immediately
  creates "/etc/sysconfig/clock.back"
end  

template "/etc/sysconfig/clock" do
  owner "root"
  group "root"
  mode "0644"
  action :nothing
end
