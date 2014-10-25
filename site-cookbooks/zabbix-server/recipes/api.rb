#
# Cookbook Name:: zabbix-server
# Recipe:: api
#

# install libraries and tools
#%w{
#    gcc
#    openssl-devel
#    git
#}.each do |pkg|
#    package pkg do
#        action :install
#    end
#end
package "git" do
    action :install
end

## git clone rbenv
#git "/home/#{node["zabbix-server"]["user"]}/.#{node["zabbix-server"]["rbenv"].split('/')[-1]}" do
#    repository  "https://github.com/#{node["zabbix-server"]["rbenv"]}.git"
#    user node["zabbix-server"]["user"]
#    group node["zabbix-server"]["group"]
#    action :sync
#end

# git clone zabbix api tool
git "/home/#{node["zabbix-server"]["user"]}/#{node["zabbix-server"]["my-zabbix-settings"].split('/')[-1]}" do
    repository  "https://github.com/#{node["zabbix-server"]["my-zabbix-settings"]}.git"
    user node["zabbix-server"]["user"]
    group node["zabbix-server"]["group"]
    action :sync
end

#directory "/home/#{node["zabbix-server"]["user"]}/.rbenv/plugins" do
#    user node["zabbix-server"]["user"]
#    group node["zabbix-server"]["group"]
#    mode 00755
#    action :create
#end
#
## git clone ruby-build and rbenv-gem-rehash
#[
#    node["zabbix-server"]["ruby-build"],
#    node["zabbix-server"]["rbenv-gem-rehash"]
#].each do |repo|
#    git "/home/#{node["zabbix-server"]["user"]}/.rbenv/plugins/#{repo.split('/')[-1]}" do
#        repository  "https://github.com/#{repo}.git"
#        user node["zabbix-server"]["user"]
#        group node["zabbix-server"]["group"]
#        action :sync
#    end
#end
#
## copy .bash_profile
#template "/home/#{node["zabbix-server"]["user"]}/.bash_profile" do
#    source ".bash_profile.erb"
#    owner node["zabbix-server"]["user"]
#    group node["zabbix-server"]["group"]
#    mode 00644
#    not_if "grep -qF '.rbenv' ~/.bash_profile", :environment => {:HOME => "/home/#{node["zabbix-server"]["user"]}"}
#end
#
## install ruby
#execute "install #{node["zabbix-server"]["ruby-version"]}" do
#    user node["zabbix-server"]["user"]
#    group node["zabbix-server"]["group"]
#    environment "HOME" => "/home/#{node["zabbix-server"]["user"]}"
#    command "/home/#{node["zabbix-server"]["user"]}/.rbenv/bin/rbenv install #{node["zabbix-server"]["ruby-version"]}"
#    not_if { File.exists?("/home/#{node["zabbix-server"]["user"]}/.rbenv/versions/#{node["zabbix-server"]["ruby-version"]}") }
#end
#
## set global
#execute "set local #{node["zabbix-server"]["ruby-version"]}" do
#    user node["zabbix-server"]["user"]
#    group node["zabbix-server"]["group"]
#    cwd "/home/#{node["zabbix-server"]["user"]}/#{node["zabbix-server"]["my-zabbix-settings"].split('/')[-1]}"
#    command "/home/#{node["zabbix-server"]["user"]}/.rbenv/bin/rbenv local #{node["zabbix-server"]["ruby-version"]}"
#    #not_if "grep -qF '#{node["zabbix-server"]["ruby-version"]}' .ruby-version", :cwd => "/home/#{node["zabbix-server"]["user"]}/#{node["zabbix-server"]["my-zabbix-settings"].split('/')[-1]}"
#end
#
#%w{bundler}.each do |gem|
#    execute "gem install #{gem}" do
#        user node["zabbix-server"]["user"]
#        group node["zabbix-server"]["group"]
#        command "/home/#{node["zabbix-server"]["user"]}/.rbenv/shims/gem install #{gem}"
#        not_if "/home/#{node["zabbix-server"]["user"]}/.rbenv/shims/gem list | grep -qF '#{gem}'"
#    end
#end
%w{bundler}.each do |gem|
    execute "gem install #{gem}" do
        command "gem install #{gem}"
        not_if "gem list | grep -qF '#{gem}'"
    end
end

#execute "install #{node["zabbix-server"]["my-zabbix-settings"]} gems" do
#    user node["zabbix-server"]["user"]
#    group node["zabbix-server"]["group"]
#    cwd "/home/#{node["zabbix-server"]["user"]}/my-zabbix-settings"
#    command "/home/#{node["zabbix-server"]["user"]}/.rbenv/shims/bundle install"
#    not_if "ruby -rzabbixapi -e ''"
#end
gem_package "zabbixapi" do
    action :install
end

#bash "test" do
#    user node["zabbix-server"]["user"]
#    group node["zabbix-server"]["group"]
#    cwd "/home/#{node["zabbix-server"]["user"]}/my-zabbix-settings"
#    code <<-EOT
#        ./delete-all-templates.rb
#    EOT
#end

