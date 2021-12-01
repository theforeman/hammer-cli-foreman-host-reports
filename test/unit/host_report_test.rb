require File.join(File.dirname(__FILE__), 'test_helper')

describe HammerCLIForemanHostReports::HostReport do
  include ::CommandTestHelper

  context 'ListCommand' do
    before do
      ResourceMocks.mock_action_call(:host_reports, :index, [])
    end

    let(:cmd) { HammerCLIForemanHostReports::HostReport::ListCommand.new('', ctx) }

    context 'parameters' do
      it_should_accept 'no arguments'
      it_should_accept_search_params
    end

    context 'output' do
      let(:expected_record_count) { count_records(cmd.resource.call(:index)) }

      it_should_print_n_records
      it_should_print_column 'Id'
      it_should_print_column 'Host'
      it_should_print_column 'Format'
      it_should_print_column 'Reported at'
      it_should_print_column 'Applied'
      it_should_print_column 'Failed'
      it_should_print_column 'Pending'
      it_should_print_column 'Other'
    end
  end

  context 'InfoCommand' do
    let(:cmd) { HammerCLIForemanHostReports::HostReport::InfoCommand.new('', ctx) }

    context 'parameters' do
      it_should_accept 'idi', ['--id=1']
    end
  end

  context 'DeleteCommand' do
    let(:cmd) { HammerCLIForemanHostReports::HostReport::DeleteCommand.new('', ctx) }

    context 'parameters' do
      it_should_accept 'id', ['--id=1']
    end
  end
end
