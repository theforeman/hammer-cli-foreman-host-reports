ENV['TEST_API_VERSION'] = ENV['TEST_API_VERSION'] || '3.1'
FOREMAN_HOST_REPORTS_VERSION = Gem::Version.new(ENV['TEST_API_VERSION']).to_s

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest-spec-context'
require 'mocha/minitest'
require 'hammer_cli'

HammerCLI.context[:api_connection].create('foreman') do
  HammerCLI::Apipie::ApiConnection.new(
    apidoc_cache_dir: 'test/data/' + FOREMAN_HOST_REPORTS_VERSION,
    apidoc_cache_name: 'foreman_api',
    dry_run: true
  )
end

require 'hammer_cli_foreman_host_reports'
