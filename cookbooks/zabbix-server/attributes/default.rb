default["zabbix"]["version"]   = "2.2"
default["zabbix"]["repo-name"] = "zabbix-release-#{node['zabbix']['version']}-1.el6.noarch.rpm"
default["zabbix"]["repo-url"]  = "http://repo.zabbix.com/zabbix/#{node['zabbix']['version']}/rhel/6/x86_64/#{node['zabbix']['repo-name']}"

