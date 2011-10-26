# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "Binflip"
  s.version     = '0.0.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Kaney"]
  s.email       = ["brian@vermonster.com"]
  s.homepage    = ""
  s.summary     = %q{Kanban Flipper}
  s.description = %q{Kanban Flipper for Rails, support for cucumber}

  s.add_dependency 'rake', '0.9.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "tools"]
end
