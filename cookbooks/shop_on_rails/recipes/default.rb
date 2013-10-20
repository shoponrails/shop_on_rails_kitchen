# encoding: utf-8

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
end

package 'git'
package 'imagemagick'
package 'nginx'
package 'libstdc++5'
package 'postfix'
package 'libxml2-dev'
package 'libxslt-dev'
package 'libmysql-ruby'
package 'libmysqlclient-dev'
package 'mc'

gem_package "bundler" do
  action :install
end


execute "Generate locales (to avoid 'boost' lib errors)" do
  command "locale-gen en_US.UTF-8 ru_RU.UTF-8"
end

include_recipe "mysql::server"

mysql_password = node[:mysql][:server_root_password]
mysql_user_name = node[:mysql][:user_name]
mysql_user_password = node[:mysql][:user_password]

execute "create MySQL user" do
  command "/usr/bin/mysql -u root -p#{mysql_password} -D mysql -r -B -N -e \"GRANT ALL PRIVILEGES ON *.* TO '#{mysql_user_name}'@'localhost' IDENTIFIED BY '#{mysql_user_password}' WITH GRANT OPTION;\""
  action :run
  not_if { `/usr/bin/mysql -u root -p#{mysql_password} -D mysql -r -B -N -e \"SELECT COUNT(*) FROM user where User='#{mysql_user_name}'"`.to_i == 1 }
end

hostname = node[:hostname]

file '/etc/hostname' do
  content "#{hostname}\n"
end

#TODO fix for restart hostname service
#service 'hostname' do
#  action :restart
#end

file '/etc/hosts' do
  content "127.0.0.1 localhost #{hostname}\n"
end

chef_gem "ruby-shadow"

cookbook_file '/etc/sudoers.d/deployer_sudo' do
  mode "0440"
end

user node[:user] do
  comment "Rails App Deployer"
  gid "users"
  home "/home/#{node[:user]}"
  shell "/bin/bash"
  #password must be encrypted
  # example: `openssl passwd -1 "p@$$w0rd"`
  password node[:deploy_user][:encoded_password]
end

directory "/home/#{node[:user]}" do
  action :create
  owner node[:user]
  group "users"
  mode "700"
end

directory "/home/#{node[:user]}/.ssh" do
  action :create
  owner node[:user]
  group "users"
  mode "700"
  recursive true
end

cookbook_file "/home/#{node[:user]}/.ssh/id_rsa" do
  mode "0600"
  owner node[:user]
  group "users"
end

cookbook_file "/home/#{node[:user]}/.ssh/id_rsa.pub" do
  mode "0644"
  owner node[:user]
  group "users"
end

#
# username = "deployer"
# execute "generate ssh skys for #{username}." do
#   user username
#   creates "/home/#{username}/.ssh/id_rsa.pub"
#   command "ssh-keygen -t rsa -q -f /home/#{username}/.ssh/id_rsa -P \"\""
# end

include_recipe "rvm::user"
include_recipe "openssl::default"

