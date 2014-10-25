#
# Cookbook Name:: ec2-linux
# Recipe:: change-editor
#

case node[:platform]
when "ubuntu"
  bash "change default editor" do
    code <<-EOT
      update-alternatives --set editor /usr/bin/vim.basic
    EOT
    not_if "update-alternatives --get-selections | grep -F 'editor' | grep -qF '/usr/bin/vim.basic'"
  end
end

