default["zabbix"]["version"]         = "2.2"
default["zabbix"]["rhel-repo"]       = "zabbix-release-#{default['zabbix']['version']}-1.el6.noarch.rpm"
default["zabbix"]["rhel-repo-url"]   = "http://repo.zabbix.com/zabbix/#{default['zabbix']['version']}/rhel/6/x86_64/#{default['zabbix']['rhel-repo']}"
default["zabbix"]["debian-repo"]     = "zabbix-release_#{default['zabbix']['version']}-1+trusty_all.deb"
default["zabbix"]["debian-repo-url"] = "http://repo.zabbix.com/zabbix/#{default['zabbix']['version']}/ubuntu/pool/main/z/zabbix-release/#{default['zabbix']['debian-repo']}"

