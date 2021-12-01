module HammerCLIForemanHostReports
  require 'hammer_cli'
  require 'hammer_cli_foreman'

  require 'hammer_cli_foreman_host_reports/version'
  require 'hammer_cli_foreman_host_reports/command_extensions'
  require 'hammer_cli_foreman_host_reports/host_report'

  HammerCLI::MainCommand.lazy_subcommand(
    'host-report',
    'Manage host reports',
    'HammerCLIForemanHostReports::HostReport',
    'hammer_cli_foreman_host_reports/host_report'
  )
end
