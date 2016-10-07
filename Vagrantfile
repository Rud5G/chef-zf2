# -*- mode: ruby -*-
# vi: set ft=ruby :

CHEF_VM_NAME = 'zf2tutorial-zf2'
CHEF_VM_HOSTNAME = 'zf2tutorial.zf2.dev'
CHEF_VM_ENVIRONMENT = 'development'

VM_IP_ADDRESS = '10.9.8.8'
VAGRANTFILE_API_VERSION = '2'
VAGRANT_MIN_VERSION = '1.7.4'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Check Vagrant version
  if Vagrant::VERSION < VAGRANT_MIN_VERSION
    puts "FATAL: Cookbook depends on Vagrant #{VAGRANT_MIN_VERSION} or higher."
    exit
  end

# Plugin-specific configurations
  # Detects vagrant cachier plugin
  if Vagrant.has_plugin?('vagrant-cachier')
    puts 'INFO:  Vagrant-cachier plugin detected. Optimizing caches.'
    config.cache.auto_detect = true
    config.cache.enable :chef
    config.cache.enable :apt
  else
    puts 'WARN:  Vagrant-cachier plugin not detected. Continuing unoptimized.'
  end

  # Detects vagrant omnibus plugin
  if Vagrant.has_plugin?('vagrant-omnibus')
    puts 'INFO:  Vagrant-omnibus plugin detected.'
    config.omnibus.chef_version = :latest
  else
    puts "FATAL: Vagrant-omnibus plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-omnibus' from any other directory\n       before continuing."
    exit
  end

  # Detects vagrant berkshelf plugin
  if Vagrant.has_plugin?('berkshelf')
    puts 'INFO:  Vagrant-berkshelf plugin detected.'
    # The path to the Berksfile to use with Vagrant Berkshelf
    config.berkshelf.berksfile_path = './Berksfile'
    config.berkshelf.enabled = true
  else
    puts "FATAL: Vagrant-berkshelf plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-berkshelf' from any other directory\n       before continuing."
    exit
  end

  # Detects vagrant hostmanager plugin
  if Vagrant.has_plugin?('vagrant-hostmanager')
    puts 'INFO:  Vagrant-hostmanager plugin detected.'
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.hostmanager.aliases = [CHEF_VM_HOSTNAME]
  else
    puts "WARN:  Vagrant-hostmanager plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-hostmanager' from any other directory\n       before continuing."
  end

  # Add additional virtualhost aliases
  Dir[Pathname(__FILE__).dirname.join('data_bags','virtualhosts','*.json')].each do |databagfile|
    config.hostmanager.aliases << JSON.parse(Pathname(__FILE__).dirname.join('data_bags','virtualhosts',databagfile).read)['development']['server_name']
    JSON.parse(Pathname(__FILE__).dirname.join('data_bags','virtualhosts',databagfile).read)['development']['server_aliases'].each do |serveralias|
      config.hostmanager.aliases << serveralias
    end
  end

  # rmemove duplicate
  config.hostmanager.aliases = config.hostmanager.aliases.uniq!

  # vm config
  config.vm.hostname = CHEF_VM_HOSTNAME

# config.vm.box = 'opscode-ubuntu-14.04'
# config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'

  config.vm.box = 'opscode-ubuntu-16.04'
  config.vm.box_url = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-16.04_chef-provisionerless.box'


  config.vm.network :private_network, :ip => VM_IP_ADDRESS

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.
    vb.customize [
      'modifyvm', :id,
      '--memory', '1024',
      '--cpus', '2',
    ]
  end

  # Enable SSH agent forwarding for git clones
  config.ssh.forward_agent = true

  # provision config
  config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = 'cookbooks'
    chef.data_bags_path = 'data_bags'
    chef.environments_path = 'environments'
    chef.roles_path = 'roles'
    chef.nodes_path = 'nodes'


    chef.synced_folder_type = :nfs

    chef.node_name = CHEF_VM_NAME
    chef.environment = CHEF_VM_ENVIRONMENT

    chef.log_level = :info
    # chef.log_level = :debug
    chef.verbose_logging = true

    chef.json = {
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      }
    }

    chef.run_list = %w(
      recipe[zf2::servernode]
      recipe[zf2::development]
    )
  end
end
