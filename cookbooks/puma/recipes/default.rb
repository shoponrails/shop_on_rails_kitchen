# Cookbook Name:: puma
# Recipe:: default
#

template "/etc/init.d/puma" do
  owner "root"
  group "root"
  mode 0755
  source "puma.erb"
end

execute "start-puma-server" do
  command %Q{
        /etc/init.d/puma start
      }
end
