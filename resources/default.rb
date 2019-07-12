# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
actions :install

property :source, String
# property :version_number, String, name_property: true

version_number = node['redis']['version']

action :install do
    # download http://download.redis.io/releases/redis-2.8.9.tar.gz
  remote_file "/tmp/redis-#{version_number}.tar.gz" do
    source "http://download.redis.io/releases/redis-#{version_number}.tar.gz"
    notifies :run, "execute[unzip_redis_archive]", :immediately
  end
  
  # unzip the archive
  execute 'unzip_redis_archive' do
    command "tar xzf /tmp/redis-#{version_number}.tar.gz"
    cwd "/tmp"
    action :nothing
    notifies :run, "execute[build_and_install_redis]", :immediately
  end
  
  # Configure the application: make and make install
  execute "build_and_install_redis" do
    command "make && make install"
    cwd "/tmp/redis-#{version_number}"
    action :nothing
    notifies :run, "execute[install_server_redis]", :immediately
  end
  
  # Install the Server
  execute "install_server_redis" do
    command "echo -n | ./install_server.sh"
    cwd "/tmp/redis-#{version_number}/utils"
    action :nothing
  end

end