template "#{node.nginx.dir}/sites-available/wiki11.conf" do
  source 'wiki11.conf.erb'
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

nginx_site 'wiki11.conf'
