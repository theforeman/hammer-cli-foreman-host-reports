lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hammer_cli_foreman_host_reports/version'

Gem::Specification.new do |spec|
  spec.name          = 'hammer_cli_foreman_host_reports'
  spec.version       = HammerCLIForemanHostReports.version.dup
  spec.authors       = ['Oleh Fedorenko']
  spec.email         = ['ofedoren@redhat.com']
  spec.homepage      = 'https://github.com/theforeman/hammer-cli-foreman-host-reports'
  spec.license       = 'GPL-3.0'

  spec.platform      = Gem::Platform::RUBY
  spec.summary       = 'Foreman Host Reports plugin for Hammer CLI'

  spec.files         = Dir['{lib,config}/**/*', 'LICENSE', 'README*']
  spec.require_paths = ['lib']
  spec.test_files    = Dir['{test}/**/*']

  spec.add_dependency 'hammer_cli_foreman', '>= 3.0.0', '< 4.0.0'
end
