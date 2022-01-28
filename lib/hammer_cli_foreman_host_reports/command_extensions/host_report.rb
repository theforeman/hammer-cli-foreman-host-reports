# frozen_string_literal: true

module HammerCLIForemanHostReports
  module CommandExtensions
    class HostReport < HammerCLI::CommandExtensions
      output do |definition, _, command_class|
        definition.append do
          field :id, _('Id')
          field :host_name, _('Host')
          field :reported_at, _('Reported at'), Fields::Date
          field :format, _('Format')
        end
        summary = proc do
          field :change, _('Change')
          field :nochange, _('No change')
          field :failure, _('Failure')
        end
        if command_class.action == :show
          definition.insert(:after, :host_name) do
            field :host_id, _('Host id')
            field :proxy_name, _('Proxy')
            field :proxy_id, _('Proxy id')
            field :keywords, _('Keywords'), Fields::List
          end
          definition.insert(:after, :format) do
            label _('Summary'), id: :summary, &summary
          end
        else
          definition.insert(:after, :format, &summary)
        end
      end

      before_print do |data, _, command_class|
        if command_class.action == :show
          begin
            parsed = JSON.parse(data['body'])
            data['format'] = parsed['format']&.capitalize
            case parsed['format']
            when 'ansible'
              HammerCLIForemanHostReports::CommandExtensions::HostReport.adjust_for_ansible(command_class, data, parsed)
            when 'puppet'
              HammerCLIForemanHostReports::CommandExtensions::HostReport.adjust_for_puppet(command_class, data, parsed)
            end
          rescue StandardError => e
            command_class.logger.debug("Could not parse report's body: #{e.message}")
          end
        end
      end

      def self.adjust_for_ansible(command_class, data, parsed)
        command_class.output_definition.insert(:after, :format) do
          field :check_mode, _('Check mode'), Fields::Boolean
        end
        command_class.output_definition.insert(:after, :summary) do
          collection :logs, _('Logs') do
            field :level, _('Level')
            field :task, _('Task')
            field :message, _('Message')
          end
        end
        data['check_mode'] = parsed['check_mode']
        data['logs'] = parsed['results']&.each_with_object([]) do |log, logs|
          logs << {
            level: log['level'],
            task: log['task']['name'],
            message: log['friendly_message']
          }
        end
      end

      def self.adjust_for_puppet(command_class, data, parsed)
        command_class.output_definition.insert(:after, :format) do
          field :environment, _('Puppet environment')
        end
        command_class.output_definition.insert(:after, :summary) do
          collection :logs, _('Logs') do
            field :level, _('Level')
            field :resource, _('Resource')
            field :message, _('Message')
          end
        end
        data['environment'] = parsed['environment']
        data['logs'] = parsed['logs']&.each_with_object([]) do |log, logs|
          logs << {
            level: log[0],
            resource: log[1],
            message: log[2]
          }
        end
      end
    end
  end
end
