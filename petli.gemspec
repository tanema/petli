# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'petli'

Gem::Specification.new do |s|
  s.name          = 'petli'
  s.version       = Petli::VERSION
  s.platform      = Gem::Platform::RUBY
  s.author        = 'Tim Anema'
  s.email         = ['timanema@gmail.com']
  s.homepage      = 'https://github.com/tanema/petli'
  s.license       = "MIT"
  s.summary       = 'A little pet in your console'
  s.description   = <<~HERE
    A virtual pet that will live in your command line!
  HERE
  s.post_install_message = <<~HERE

    I am so happy to meet you!

       ʕ=ʔ 乁(☯ ᴥ ☯)ㄏ ▷☯◁

  HERE
  s.metadata      = { "source_code_uri" => "https://github.com/tanema/petli" }

  s.files         = Dir.glob('{bin/*,lib/**/*,data/**/*,[A-Z]*}')
  s.bindir        = "bin"
  s.executables   = ["petli"]
  s.require_paths = ['lib']

  s.required_ruby_version = ">= 2.6"

  s.add_dependency("pastel", "~> 0.8.0")
  s.add_dependency("tty-cursor", "~> 0.7.1")
  s.add_dependency("tty-screen", "~> 0.8.1")
  s.add_dependency("tty-reader", "~> 0.9.0")
  s.add_dependency("tty-color", "~> 0.6.0")
  s.add_dependency("tty-box", "~> 0.7.0")
  s.add_dependency("tty-platform", "~> 0.3.0")
end
