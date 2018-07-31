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
