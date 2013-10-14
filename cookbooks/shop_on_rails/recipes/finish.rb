# encoding: utf-8

execute "Start ShopOnRails Demo Application" do
  command "/etc/init.d/unicorn_#{node[:app_name]} start"
  action :run
end

service 'nginx' do
  action :restart
end