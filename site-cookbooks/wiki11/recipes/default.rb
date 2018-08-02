#
# Cookbook:: wiki11
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'acme'

template "#{node.nginx.dir}/sites-available/wiki11.conf" do
  source 'wiki11.conf.erb'
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

nginx_site 'wiki11.conf'

node.override['acme']['contact'] = ['mailto:wiki11official@gmail.com']

acme_certificate '192.168.1.6' do
  crt               '/etc/ssl/certs/wiki11.pem'
  chain             '/etc/ssl/certs/wiki11.pem.chained.pem'
  key               '/etc/ssl/wiki11.com.key'
  wwwroot           '/home/deployer/www'
end

%w(nginx.conf puma.conf).each do |conf_file|
  cookbook_file "/etc/monit/conf.d/#{conf_file}" do
    user 'root'
    group 'root'
    mode '0655'
    notifies :restart, resources(service: 'monit'), :delayed
  end
end

monit_monitrc 'sidekiq'

app_shared_path = '/home/deployer/www/wiki11/shared'
daemon_stdout = File.join(app_shared_path, 'log', 'sidekiq.log')
daemon_stderr = File.join(app_shared_path, 'sidekiq-err.log')
daemon_path = '/home/deployer/www/wiki11/current'
env = { 'APP_ENV' => 'production' }

wiki11_servicify_service 'sidekiq' do
  template_source 'etc.init.d.sidekiq.erb'
  template_cookbook 'wiki11'
  script_description '"Sidekiq"'
  script_path '/sbin:/usr/sbin:/bin:/usr/bin:/home/deployer/.rvm/rubies/ruby-2.5.0/bin/ruby'
  script_daemon '/home/deployer/.rvm/gems/ruby-2.5.0@global/bin/bundle'
  script_daemon_args '"exec sidekiq --index 0 --pidfile /home/deployer/www/wiki11/shared/tmp/pids/sidekiq.pid --environment $APP_ENV --logfile /home/deployer/www/wiki11/shared/log/sidekiq.log --queue high --queue default --concurrency 5 --daemon"'
  script_daemon_path daemon_path
  script_daemon_stdout daemon_stdout
  script_daemon_stderr daemon_stderr
  script_pidfile "/home/deployer/www/wiki11/shared/tmp/pids/sidekiq.pid"
  script_env env
  restart_pids_script "ps -ef | grep sidekiq | awk '{print $2}'"
end

ruby_block 'monit reload' do
  block do
    require 'mixlib/shellout'
    cmnd = Mixlib::ShellOut.new('monit start all')
    cmnd.run_command
    if cmnd.error?
      cmndd = Mixlib::ShellOut.new('monit reload')
      cmndd.run_command
    else
      puts cmnd.stdout
    end
  end
  action :run
end

# Email address that will be notified of events.
node.override['monit']['alert_email'] = 'root@localhost'

node.override['monit']['mail'] = {
  hostname: ENV['MAILER_HOST'],
  port:     587,
  username: ENV['MAILER_USER_NAME'],
  password: ENV['MAILER_PASSWORD'],
  encrypted_credentials: nil,
  encrypted_credentials_data_bag: "credentials",
  from:     "monit@$HOST",
  subject:  "$SERVICE $EVENT at $DATE",
  message:  "Monit $ACTION $SERVICE at $DATE on $HOST,\n\n$DESCRIPTION\n\nDutifully,\nMonit",
  security: nil,  # 'SSLV2'|'SSLV3'|'TLSV1'
  timeout:  30,
  using_hostname: nil
}

