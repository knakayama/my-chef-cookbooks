#
# Cookbook Name:: ec2-linux
# Recipe:: change-editor
#

case node[:platform]
when "ubuntu"
  template "/etc/apt/sources.list" do
    source "sources.list.erb"
    owner  "root"
    group  "root"
    mode   00644
  end

  bash "update apt source" do
    code <<-EOT
      apt-get update -y
      apt-get upgrade -y
    EOT
  end
end

