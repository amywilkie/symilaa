# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "symilaa/version"

Gem::Specification.new do |s|
  s.name        = "symilaa"
  s.version     = Symilaa::VERSION
  s.authors     = ["jamienglish,drpep"]
  s.email       = ["skyhelpcentre@gmail.com"]
  s.homepage    = "https://github.com/bskyb-commerce-helpcentre/symilaa"
  s.summary     = %q{Compares images for similarity.  Amazebears.}
  s.description = %q{Using the wonders of RMagick, this wonderful gem will produce a boolean result based on the computed similarity
    of the two images passed.}

  s.rubyforge_project = "symilaa"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "rake"

  s.add_development_dependency 'rb-inotify' if RUBY_PLATFORM =~ /linux/

  s.add_runtime_dependency "rmagick"
end
