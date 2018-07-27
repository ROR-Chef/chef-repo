current_dir = File.dirname(__FILE__)

cookbook_path    ["cookbooks", "site-cookbooks"]
node_path        "nodes"
role_path        "roles"
environment_path "environments"
data_bag_path    "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"
Chef::Config[:ssl_verify_mode] = :verify_peer if defined? ::Chef

knife[:solo] = true
knife[:ssh_user] = 'deployer'

if ENV['CHEF_ENV'] && ENV['CHEF_ENV'] !~ /production|staging|development/
  Chef::Application.fatal!("Environment should be either production or staging.")
end

knife[:environment] = ENV['CHEF_ENV']

if ENV['CHEF_AWS_ACCESS_KEY_ID'] && ENV['CHEF_AWS_SECRET_ACCESS_KEY']
  Chef::Config.from_file(File.join(current_dir, 'knife-ec2.rb'))
end

log_level                :info
log_location             STDOUT
node_name                "neerajk"
client_key               "#{current_dir}/neerajk.pem"
chef_server_url          "https://api.chef.io/organizations/wiki11-chef"


