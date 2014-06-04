# ZF2 cookbook

# Requirements

Install Vagrant '>= 1.5.2' from the [Vagrant downloads page](http://www.vagrantup.com/download-archive/v1.5.2.html)
Install the Vagrant plugins: Berkshelf, Omnibus, Hostmanager

    $ vagrant plugin install vagrant-berkshelf --plugin-version '>= 2.0.1'
    $ vagrant plugin install vagrant-omnibus
    $ vagrant plugin install vagrant-hostmanager

# Usage

Set the required project (git), database, virtualhost & users in the databags

    $ vagrant up
    $ vagrant halt


## Issues 

The samba user setup is not done correct in the first run, to fix: 

    $ vagrant ssh
    $ sudo su
    $ smbpasswd -x developer
    $ exit # (2x)
    $ vagrant provision

# Attributes

# Recipes

# Author

Author:: Triple-networks (<r.gravestein@triple-networks.com>)

