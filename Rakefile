# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'rake/clean'

Hoe.plugin :bundler
#Hoe.plugin :git

CLEAN.include '**/#*.*#'
Hoe.spec 'change_names' do
    developer("Dominic Sisneros", "dsisnero@gmail.com")
  dependency("methadone", "> 0.0.0")
  dependency("pry", "~> 0.9.12",:dev)
  dependency("pry-nav","~> 0.2",:dev)
  dependency("hoe-bundler", ">=1.1", :dev)
 # dependency("hoe-git", ">=1.6", :dev)
  license("MIT")


  # self.rubyforge_name = 'change_namesx' # if different than 'change_names'
end

# vim: syntax=ruby
