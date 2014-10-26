# Cookbook Name:: zabbix-client
# Recipe:: default
#

case node[:platform_family]
when "rhel"
  repo     = node["zabbix"]["rhel-repo"]
  repo_url = node["zabbix"]["rhel-repo-url"]
when "debian"
  repo     = node["zabbix"]["debian-repo"]
  repo_url = node["zabbix"]["debian-repo-url"]
end
remote_file "#{Chef::Config[:file_cache_path]}/#{repo}" do
    source repo_url
end

case node[:platform_family]
when "rhel"
  repo = node["zabbix"]["rhel-repo"]
  provider = Chef::Provider::Package::Rpm
when "debian"
  repo = node["zabbix"]["debian-repo"]
  provider = Chef::Provider::Package::Dpkg
end
package "#{Chef::Config[:file_cache_path]}/#{repo}" do
    provider provider
    action :install
end

%w{zabbix-agent}.each do |pkg|
    package pkg do
        action :install
    end
end

case node[:platform_family]
when "rhel"
  path = "zabbix_agentd.conf.rhel.erb"
when "debian"
  path = "zabbix_agentd.conf.debian.erb"
end
template "/etc/zabbix/zabbix_agentd.conf" do
    source path
    owner  "root"
    group  "root"
    mode   00644
    notifies :restart, "service[zabbix-agent]"
end

case node[:platform_family]
when "rhel"
  path = "/etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf"
when "debian"
  path = "/etc/zabbix/zabbix_agentd.conf.d/userparameter_mysql.conf"
end
template path do
    source "userparameter_mysql.conf.erb"
    owner  "root"
    group  "root"
    mode   00644
    notifies :restart, "service[zabbix-agent]"
end

case node[:platform_family]
when "rhel"
  service "zabbix-agent" do
      supports :status => true, :restart => true, :reload => true
      action [:enable, :start]
  end
when "debian"
  service "zabbix-agent" do
      supports :status => true, :restart => true
      action [:enable, :start]
  end
end

