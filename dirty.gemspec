# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dirty/version"

Gem::Specification.new do |s|
  s.name        = "dirty"
  s.version     = Dirty::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robert Pitts"]
  s.email       = ["rbxbxdev@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Run those dirty tests!}
  s.description = %q{Easily run dirty cucumber features and rspec specs in your current project
                     if you're using git}

  s.rubyforge_project = "dirty"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
