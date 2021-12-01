# frozen_string_literal: true

module HammerCLIForemanHostReports
  class HostReport < HammerCLIForeman::Command
    resource :host_reports

    class ListCommand < HammerCLIForeman::ListCommand
      build_options

      extend_with(HammerCLIForemanHostReports::CommandExtensions::HostReport.new)
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      build_options

      extend_with(HammerCLIForemanHostReports::CommandExtensions::HostReport.new)
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message _('Host report created.')
      failure_message _('Could not create the host report')

      build_options
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message _('Host report deleted.')
      failure_message _('Could not delete the host report')

      build_options
    end

    autoload_subcommands
  end
end
