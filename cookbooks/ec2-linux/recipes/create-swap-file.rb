bash 'create swapfile' do
    code <<-EOT
        dd if=/dev/zero of=/swap.img bs=1M count=2048
        chmod 600 /swap.img
        mkswap /swap.img
    EOT
    only_if { not node[:ec2].nil? and node[:ec2][:instance_type] == 't1.micro' }
    creates '/swap.img'
end

# swap file entry for fstab
mount '/dev/null' do
    # connot mount: only add to fstab
    action :enable
    device '/swap.img'
    fstype 'swap'
    only_if { not node[:ec2].nil? and node[:ec2][:instance_type] == 't1.micro' }
end

bash 'activate swap' do
    code 'swapon -ae'
    only_if '[ "$(wc -l /proc/swaps)" -eq 1]'
end

