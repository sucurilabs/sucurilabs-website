ENV['GEM_HOME']="#{ENV['HOME']}/.rvm/gems/ruby-1.9.3-p194@global"
ENV['GEM_PATH']="#{ENV['GEM_HOME']}"
require 'rubygems'
Gem.clear_paths
# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
 require 'bundler'
  Bundler.setup
run SucurilabsWebsite::Application
