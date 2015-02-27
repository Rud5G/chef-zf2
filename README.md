# ZF2 cookbook
--------------

[![Build Status](https://travis-ci.org/Rud5G/chef-zf2.png?branch=master)](https://travis-ci.org/Rud5G/chef-zf2)
[![Dependency Status](https://gemnasium.com/Rud5G/chef-zf2.png)](https://gemnasium.com/Rud5G/chef-zf2)
[![Version Status](http://img.shields.io/badge/beta-0.7.0-blue.svg)](https://github.com/Rud5G/chef-zf2)

# Requirements

Install chef-dk from the downloads page on the [Chef-DK github page](https://github.com/opscode/chef-dk)

Install latest Vagrant from the [Vagrant downloads page](https://www.vagrantup.com/downloads.html)

Install the Vagrant plugins: Berkshelf, Omnibus, Hostmanager

    $ vagrant plugin install vagrant-berkshelf
    $ vagrant plugin install vagrant-omnibus
    $ vagrant plugin install vagrant-hostmanager

# Usage

Set the required project (git), database, virtualhost & users in the databags

    $ vagrant up
    $ vagrant halt

## Known Issues

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


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Rud5G/chef-zf2/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

