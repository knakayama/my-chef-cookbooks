# Cookbook Name:: zabbix-client
# Recipe:: default
#

# add zabbix 2.2 yum repository
remote_file "#{Chef::Config[:file_cache_path]}/#{node['zabbix']['repo-name']}" do
    source node['zabbix']['repo-url']
end

rpm_package "add zabbix repo" do
    source "#{Chef::Config[:file_cache_path]}/#{node['zabbix']['repo-name']}"
    action :install
end

%w{zabbix-agent}.each do |pkg|
    package pkg do
        action :install
    end
end

template '/etc/zabbix/zabbix_agentd.conf' do
    source 'zabbix_agentd.conf.erb'
    owner 'root'
    group 'root'
    mode 00644
    notifies :restart, 'service[zabbix-agent]'
end

service 'zabbix-agent' do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

