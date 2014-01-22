# -*- encoding: utf-8 -*-

Gem.Specification.new do |s|
  s.name             = "gargle"
  s.version          = "Gargle::Version::STRING"
  s.platform         = "Gem::Platform::RUBY"
  s.authors          = ["Abraham Polishchuk"]
  s.email            = "apolishc@gmail.com"
  s.license          = "LGPL"
  s.copyright        = "GoBalto, Inc"
  s.description      = "Run Order randomization through Genetic Algorithms"
  s.files            = `git ls-files -- lib/*`.split("\n")
  s.files           += ["License.txt"]
  s.require_path     = 'lib'
end