# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :solo do |solo_config|
    solo_config.vm.forward_port 80, 8080

    solo_config.vm.box = "shop_on_rails_ubuntu_server_amd64"
    solo_config.vm.box_url = "https://dl.dropboxusercontent.com/u/17010047/ubuntu-12.0.4-lts-server-amd64.box"
    solo_config.vm.network :hostonly, "33.33.33.10", :netmask => "255.255.255.0"
    solo_config.vm.share_folder "v-cookbooks", "/chef", "."
  end

  config.vm.define :solo_local do |solo_config|
    solo_config.vm.forward_port 80, 8080

    solo_config.vm.box = "shop_on_rails_ubuntu_server_amd64"
    solo_config.vm.box_url = "~/Dropbox/Public/ubuntu-12.0.4-lts-server-amd64.box"
    solo_config.vm.network :hostonly, "33.33.33.10", :netmask => "255.255.255.0"
    solo_config.vm.share_folder "v-cookbooks", "/chef", "."
  end

end
