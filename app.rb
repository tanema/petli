require 'rubygems'
require 'bundler'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('./Gemfile', __dir__)
Bundler.require :default
$LOAD_PATH.unshift("./lib")
require 'petli'
