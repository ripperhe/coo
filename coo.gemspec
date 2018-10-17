# coding: utf-8
require File.join([File.dirname(__FILE__),'lib','coo','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'coo'
  s.version = Coo::VERSION
  s.author = 'ripperhe'
  s.email = '453942056@qq.com'
  s.homepage = 'https://github.com/ripperhe/coo'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A useful gem for iOS developer. 🚀'
  s.files = `git ls-files`.split
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'coo'

  s.add_runtime_dependency('gli', '~> 2.18')
  s.add_runtime_dependency('colorize', '~> 0.8')
  s.add_runtime_dependency('terminal-table', '~> 1.8')
  # s.add_runtime_dependency('cocoapods', '~> 1.5')
  # s.add_runtime_dependency('fastlane', '~> 2.0')

  # development
  s.add_development_dependency('rake', '~> 12.3')

end
