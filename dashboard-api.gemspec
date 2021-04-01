lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dashboard-api/version'

Gem::Specification.new do |s|
  s.name        = 'dashboard-api'
  s.version     = DashboardAPIVersion::VERSION
  s.authors     = ['Joe Letizia', 'Shane Short']
  s.email       = ['letiziajm@gmail.com', 'shanes@webinabox.net.au']

  s.summary     = %q{A Ruby implementation of the Meraki Dashboard API}
  s.description = %q{A Ruby implementation of the Meraki Dashboard API. It allows you to interact and provision the Meraki Dashboard via their RESTful API}
  s.homepage    = "https://github.com/shaneshort/dashboardapi"

  s.files       = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.require_paths = ['lib']
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "yard", "~> 0.9.11"
  s.add_development_dependency "vcr", ">= 3.0.3"
  s.add_development_dependency "webmock", ">= 2.1.0"

  s.add_runtime_dependency "httparty", "~> 0.18.0"
end
