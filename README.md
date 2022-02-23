# Hammer CLI Foreman Host Reports

This Hammer CLI plugin contains set of commands for [foreman_host_reports](
  https://github.com/theforeman/foreman_host_reports
), a plugin to Foreman for Host Reports.

## Versions

This is the list of which version of Foreman Host Reports is needed to which version of this plugin.

| hammer_cli_foreman_host_reports | 0.0.1+ | 0.1.0+ |
|---------------------------------|--------|--------|
|            foreman_host_reports | 0.0.4+ | 1.0.0+ |

## Installation

    $ gem install hammer_cli_foreman_host_reports

    $ mkdir -p ~/.hammer/cli.modules.d/

    $ cat <<EOQ > ~/.hammer/cli.modules.d/foreman_host_reports.yml
    :foreman_host_reports:
      :enable_module: true
    EOQ

    # to confirm things work, this should return useful output
    hammer host-report --help

## More info

See our [Hammer CLI installation and configuration instuctions](
https://github.com/theforeman/hammer-cli/blob/master/doc/installation.md#installation).
