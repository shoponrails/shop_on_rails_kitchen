name             'puma'
maintainer       'ShopOnrails'
maintainer_email 'alexander.negoda@gmail.com'
license          'All rights reserved'
description      'Installs and configures puma server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe           "puma", "Install puma"

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "puma/version",
  :display_name => "Puma Version",
  :description => "Puma Version to install",
  :default => "2.0.1"

attribute "puma/bundler_version",
  :display_name => "Bundler Version",
  :description => "Bundler Version to install",
  :default => "1.3.5"
