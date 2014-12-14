# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
VAGRANT_MIN_VERSION = '1.5.2'


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
    # The path to the Berksfile to use with Vagrant Berkshelf
    puts 'INFO:  Vagrant-berkshelf plugin detected.'
    config.berkshelf.berksfile_path = './Berksfile'
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
    # config.hostmanager.aliases = %w(zf2tutorial.zf2.dev)
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
  config.hostmanager.aliases = config.hostmanager.aliases.uniq


# vm config
  config.vm.hostname = 'zf2tutorial.zf2.dev'

  config.vm.box = 'opscode-ubuntu-12.04'
  config.vm.box_url = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box'

  #config.vm.box = 'opscode-ubuntu-14.04'
  #config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'

  config.vm.network :private_network, :ip => '33.33.33.77'

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


  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = 'data_bags'
    chef.environments_path = 'environments'
    chef.roles_path = 'roles'

    chef.verbose_logging = true
    chef.log_level = :info
    # chef.log_level = :debug
    chef.node_name = 'zf2'
    chef.environment = 'development'

    # chef.provisioning_path = guest_cache_path
    chef.json = {
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      }
    }

    chef.run_list = %w(
      role[base]
      recipe[zf2::servernode]
      recipe[zf2::development]
    )
  end
end

