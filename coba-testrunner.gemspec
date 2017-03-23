Gem::Specification.new do |s|
  s.name        = 'coba-testrunner'
  s.version     = '0.0.4'
  s.date        = '2017-01-06'
  s.summary     = "test runner for selenium-webdriver"
  s.description = "run test case agains some config"
  s.authors     = ["Sunu Pinasthika Fajar"]
  s.email       = 'sunupf@gmail.com'
  s.files       = ["lib/coba-testrunner.rb","lib/template/test-ruby.rb","lib/template/before-ruby.rb","lib/template/after-ruby.rb"]
  s.homepage    = ""
  s.license     = 'MIT'
  s.executables << 'coba'
end
