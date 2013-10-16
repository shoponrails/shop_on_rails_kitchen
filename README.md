# What is it?

This repository contains the code that is required to deploy the demo site using Opscode Chef.
This will allow quickly get started with ShopOnRails even for beginners.
You can use it kitchen for deployment to a new server or for learning and development of ShopOnRails on Virtualbox.

# How to use ShopOnRails Kitchen?

There are a few variants how you can use ShopOnRails Kitchen.

### * Variant 1: You have a clean install of Ubuntu 12.x or 13.x.

For this case you must do the following steps:

```bash
    # ssh user@host
    # sudo su -
    # apt-get update && apt-get -y upgrade
    # apt-get -y git-core
    # git clone https://github.com/shoponrails/shop_on_rails_kitchen.git /chef
    # cd /chef
    # ./chef-bootstrap.sh
    # git submodule init
    # git submodule update
    # ./shop_on_rails_solo.sh
```

### * Variant 2: Running ShopOnRails site on VirtualBox instance (for Windows/MacOS/Linux users).

1. install VirtualBox from https://www.virtualbox.org/wiki/Downloads
2. `git clone https://github.com/shoponrails/shop_on_rails_kitchen.git  shop_on_rails_kitchen`  or download zip from https://github.com/shoponrails/shop_on_rails_kitchen/archive/master.zip
3. `cd shop_on_rails_kitchen && bundle install` - requires `bundler` gem to host machine
4. `vagrant up solo` - run VM instance
5. `vagrant ssh solo` or `ssh vagrant@localhost -p2222` - enter to VM instance
6. `sudo su - && /chef/shop_on_rails_solo.sh`
7. go to http://localhost:8080 - open it URL from host machine

http://localhost:8080/refinery - RefineryCMS admin area

http://localhost:8080/admin - Spree admin area

login: `admin`

password: `password`


As a result, you will have a running instance of ShopOnRails with the following configuration (currently):

* Ubuntu-12.04 LTS Server AMD64
* mysql
* unicorn
* nginx

Path to application is `/srv/shop_on_rails_app`


### For Windows users

* install RubyInstaller: http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.9.3-p448-i386-mingw32.7z?direct
* open `cmd`
* `gem.bat install bundler`
* download zip from https://github.com/shoponrails/shop_on_rails_kitchen/archive/master.zip and extract to `c:\kitchen`
* next: `cd c:/kitchen`
* `bundle.bat install`
* `vagrant.bat up solo`
* `vagrant.bat ssh solo` - login to VM
* `sudo su -`
* `apt-get update && apt-get -y upgrade`
* `apt-get -y git-core`
* `git submodule init && git submodule update`
* `/chef/shop_on_rails_solo.sh`


### Customization

 You can change some options for deployment process. Edit the file `roles/shop_on_rails.json` (see https://github.com/shoponrails/shop_on_rails_kitchen/blob/master/roles/shop_on_rails.json)
 For example, you can change the name of the database and the user:

 ```json
 "database":{
     "adapter": "mysql2",
     "database": "shop_on_rails_db",
     "host": "localhost",
     "username": "shoponrails",
     "password": "abcdef"
 }
```


## Copyright

Copyright (c) 2013 Alexander Negoda. See LICENSE.txt for further details.

