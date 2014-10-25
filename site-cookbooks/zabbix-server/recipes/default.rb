#
# Cookbook Name:: zabbix-server
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

%w{
    zabbix-server-mysql
    zabbix-server
}.each do |pkg|
    package pkg do
        action :install
    end
end

bash "create zabbix tables" do
    user "ec2-user"
    group "ec2-user"
    cwd "/usr/share/doc/zabbix-server-mysql-2.2.6/create"
    code <<-EOT
        cat schema.sql images.sql data.sql | mysql -uzabbix --password='#{node['ZABBIX_PASSWORD']}' zabbix
    EOT
    not_if { File.exist?("/var/lib/mysql/zabbix/maintenances.frm") }
end

%w{
    events
    history
    history_log
    history_str
    history_str_sync
    history_sync
    history_text
    history_uint
    history_uint_sync
}.each do |table|
    bash "change #{table} property to use Barracuda compression" do
        user "ec2-user"
        group "ec2-user"
        code <<-EOT
            mysql -uroot -D zabbix -e "ALTER TABLE #{table} ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8"
        EOT
        not_if "mysql -uroot -D zabbix -e 'SHOW CREATE TABLE #{table}\\G' | grep -qF 'ROW_FORMAT=COMPRESSED'"
    end
end

template "/etc/zabbix/zabbix_server.conf" do
    source "zabbix_server.conf.erb"
    owner "root"
    group "zabbix"
    mode 00540
    notifies :restart, "service[zabbix-server]"
end

service "zabbix-server" do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

%w{
    zabbix-web-mysql
    mod24_ssl
}.each do |pkg|
    package pkg do
        action :install
    end
end

template "/etc/httpd/conf.d/zabbix.conf" do
    source "zabbix.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, "service[httpd]"
end

bash "create htpasswd file" do
    user "root"
    code <<-EOT
        htpasswd -bc /etc/httpd/conf.d/passwd "#{node['HTPASSWD_USER']}" "#{node['HTPASSWD_PASS']}"
    EOT
    not_if { File.exist?("/etc/httpd/conf.d/passwd") }
end

bash "create private key" do
    user "root"
    code <<-EOT
        openssl req -new -newkey rsa:2048 -sha1 -x509 -nodes \
            -set_serial 1 \
            -days 365 \
            -subj "/C=JP/ST=Tokyo/L=Tokyo City/CN=#{node[:fqdn]}" \
            -out /etc/pki/tls/certs/#{node[:fqdn]}.crt \
            -keyout /etc/pki/tls/private/#{node[:fqdn]}.key
        chmod 00400 /etc/pki/tls/private/#{node[:fqdn]}.key
    EOT
    not_if { File.exist?("/etc/pki/tls/private/#{node[:fqdn]}.key") }
end

template "/etc/zabbix/web/zabbix.conf.php" do
    source "zabbix.conf.php.erb"
    owner "apache"
    group "apache"
    mode 00644
    notifies :restart, "service[httpd]"
end

service "httpd" do
    action [:enable, :start]
    supports :status => true, :restart => true, :reload => true
end

