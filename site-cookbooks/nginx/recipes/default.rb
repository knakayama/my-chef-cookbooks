#
# Cookbook Name:: nginx
# Recipe:: default
#

service "apache2" do
  action [:disable, :stop]
  only_if "dpkg --list | grep -qF 'apache2'"
end

%w{
  nginx
}.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/nginx/sites-available/default" do
  source   "default.erb"
  owner    "root"
  group    "root"
  mode     00644
  notifies :restart, "service[nginx]"
end

link "/etc/nginx/sites-enabled/default" do
  to "/etc/nginx/sites-available/default"
  not_if { File.symlink?("/etc/nginx/sites-enabled/default") }
  notifies :restart, "service[nginx]"
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

