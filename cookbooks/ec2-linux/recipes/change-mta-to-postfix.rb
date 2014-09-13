service "sendmail" do
    action [:stop, :disable]
end

package "postfix" do
    action :install
    supports :status => true, :restart => true, :reload => true
end

bash "change mta to postfix" do
    code <<-EOT
        /usr/sbin/alternatives --set mta /usr/sbin/sendmail.postfix
    EOT
    not_if "/usr/sbin/alternatives --display mta | grep -qF 'link currently points to /usr/sbin/sendmail.postfix'"
end

package "sendmail" do
    action :remove
end

service "postfix" do
    action [:start, :enable]
end

