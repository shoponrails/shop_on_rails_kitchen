# encoding: utf-8

deploy_user = node[:user]
deploy_group = node[:user_group]
database_params = node[:database]

app_name = node[:app_name]
environment = node[:environment]

['/releases', '/shared/tmp/sockets', '/shared/log', '/shared/tmp/pids', '/shared/public'].each do |catalog|
  directory "/srv/#{app_name}#{catalog}" do
    action :create
    user node[:user]
    group "users"
    recursive true
    mode "0755"
  end
end

application app_name do
  path "/srv/#{app_name}"
  owner deploy_user
  group deploy_group
  repository node[:app_repo]
  revision node[:branch]
  environment_name environment
  symlinks({"tmp/pids" => "tmp/", "tmp/sockets" => "tmp/"})
  deploy_key node[:deploy_key]

  before_symlink do
    cookbook_file "#{release_path}/.ruby-gemset" do
      mode "0644"
      owner node[:user]
      group "users"
    end

    cookbook_file "#{release_path}/.ruby-version" do
      mode "0644"
      owner node[:user]
      group "users"
    end

    if node[:generate_demo_data]
      execute 'Bootstrap demo application' do
        command "cd #{release_path} && bundle exec rake db:create && bundle exec rake shop_on_rails:setup && bundle exec rake shop_on_rails:refresh_db_with_samples"
        user deploy_user
        group deploy_group
        cwd release_path
        environment ({'RAILS_ENV' => environment})
      end
    end
  end

  rails do
    gems ['bundler']
    bundler true
    precompile_assets true
    database do
      database_params.each do |key, value|
        send(key.to_sym, value)
      end
    end
  end
end

template "apps_nginx_configs" do
  path "/etc/nginx/sites-available/#{app_name}.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 00644
  variables({
                :app_name => node[:app_name],
                :env => environment,
                :nginx_port => node[:nginx_port],
                :server_name => node[:server_name]
            })
end

link "/etc/nginx/sites-enabled/#{app_name}" do
  to "/etc/nginx/sites-available/#{app_name}.conf"
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end


template "unicorn_start_script" do
  path "/etc/init.d/unicorn_#{app_name}"
  source "unicorn_start.erb"
  owner "root"
  group "root"
  mode 00755
  variables({
                :app_name => node[:app_name],
                :env => environment
            })
end

template "unicorn_config" do
  path "/srv/#{app_name}/current/config/unicorn.rb"
  source "unicorn_config.erb"
  owner "deployer"
  group "users"
  mode 00644
  variables({
                :app_name => node[:app_name],
                :env => environment
            })
end

execute 'remove default routes.rb' do
  command "rm -rf /srv/#{app_name}/current/config/routes.rb"
end

template "routes" do
  path "/srv/#{app_name}/current/config/routes.rb"
  source "routes.rb.erb"
  owner "deployer"
  group "users"
  mode 00644
end
