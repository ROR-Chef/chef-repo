include_recipe 'acme'

template "#{node.nginx.dir}/sites-available/wiki11.conf" do
  source 'wiki11.conf.erb'
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

nginx_site 'wiki11.conf'

acme_certificate node['wiki11']['server'] do
  crt               '/etc/ssl/certs/wiki11.pem'
  chain             '/etc/ssl/certs/wiki11.pem.chained.pem'
  key               '/etc/ssl/wiki11.com.key'
  wwwroot           '/home/deployer/www'
end

file '/etc/nginx/sites-available/default' do
  action :delete
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

link '/etc/nginx/sites-enabled/wiki11.conf' do
  to '/etc/nginx/sites-available/wiki11.conf'
  action :create
end
