# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "binflip"
  s.version     = '0.0.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Kaney"]
  s.email       = ["brian@vermonster.com"]
  s.homepage    = ""
  s.summary     = %q{Kanban Flipper}
  s.description = %q{Environment-based feature flipper.  Compatiable with rollout.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "tools"]
end
