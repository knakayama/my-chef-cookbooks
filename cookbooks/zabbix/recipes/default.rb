#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# add zabbix 2.2 yum repository
remote_file "#{chef::config[:file_cache_path]/zabbix-release-2.2-1.el6.noarch.rpm}" do
   source 'http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm'
   action :create
end

rpm_package "add zabbix-2.2-1 repo" do
    source "#{chef:config[:file_cache_path]/zabbix-release-2.2-1.el6.noarch.rpm}"
    action :install
end

package "mysql-server" do
    action :install
    supports :reload => true, :restart => true, :status => true
end

service "mysql-server" do
    action [:enable, :start]
end

template "my.cnf" do
    path "/etc/my.cnf"
    owner "root"
    group "root"
    mode 0644
    notifies :reload, 'service[mysql-server]'
end

