require File.join(File.dirname(__FILE__), 'test_helper')

describe 'host report' do
  describe 'list' do
    let(:cmd) { %w[host-report list] }
    let(:params) { ['--host=host.example.com'] }
    let(:host1_report_ansible) do
      {
        id: 1,
        host_name: 'host.example.com',
        format: 'ansible',
        reported_at: '01/12/2021',
        change: 1,
        nochange: 2,
        failure: 1
      }
    end
    let(:host1_report_puppet) do
      {
        id: 2,
        host_name: 'host.example.com',
        format: 'puppet',
        reported_at: '01/12/2021',
        change: 1,
        nochange: 2,
        failure: 1
      }
    end
    let(:host2_report_puppet) do
      {
        id: 3,
        host_name: 'host2.example.com',
        format: 'puppet',
        reported_at: '01/12/2021',
        change: 5,
        nochange: 2,
        failure: 1
      }
    end

    it 'lists all host reports' do
      api_expects(:host_reports, :index, 'Host report list').with_params(
        'page' => 1, 'per_page' => 1000
      ).returns(index_response([host1_report_puppet, host1_report_ansible, host2_report_puppet]))

      output = IndexMatcher.new(
        [
          ['ID', 'HOST', 'REPORTED AT', 'FORMAT', 'CHANGE', 'NO CHANGE', 'FAILURE'],
          ['1', 'host.example.com', '2021/12/01 00:00:00', 'ansible', '1', '2', '1'],
          ['2', 'host.example.com', '2021/12/01 00:00:00', 'puppet', '1', '2', '1'],
          ['3', 'host2.example.com', '2021/12/01 00:00:00', 'puppet', '5', '2', '1']
        ]
      )
      expected_result = success_result(output)

      result = run_cmd(cmd)
      assert_cmd(expected_result, result)
    end

    it 'lists all host reports for a given host' do
      api_expects(:hosts, :index, 'Host list').with_params(
        'search' => 'name = "host.example.com"'
      ).returns(index_response([{ 'id' => 1 }]))
      api_expects(:host_reports, :index, 'Host report list').with_params(
        'host_id' => 1, 'page' => 1, 'per_page' => 1000
      ).returns(index_response([host1_report_puppet, host1_report_ansible]))

      output = IndexMatcher.new(
        [
          ['ID', 'HOST', 'REPORTED AT', 'FORMAT', 'CHANGE', 'NO CHANGE', 'FAILURE'],
          ['1', 'host.example.com', '2021/12/01 00:00:00', 'ansible', '1', '2', '1'],
          ['2', 'host.example.com', '2021/12/01 00:00:00', 'puppet', '1', '2', '1']
        ]
      )
      expected_result = success_result(output)

      result = run_cmd(cmd + params)
      assert_cmd(expected_result, result)
    end
  end

  describe 'create' do
    let(:cmd) { %w[host-report create] }
    let(:params) do
      [
        '--host=new.example.com', '--reported-at=01/12/2021', '--body=""',
        '--format=ansible', '--change=5', '--nochange=2', '--failure=1'
      ]
    end
    let(:new_host_report) do
      {
        id: 1,
        host_id: 1,
        format: 'ansible',
        host_name: 'new.example.com',
        reported_at: '01/12/2021',
        body: nil,
        change: 5,
        failure: 1,
        nochange: 2
      }
    end

    it 'requires minimal parameters' do
      api_expects_no_call

      expected_result = "Could not create the host report:\n" \
        "  Missing arguments for '--host', '--reported-at', '--body'.\n"

      result = run_cmd(cmd)
      assert_match(expected_result, result.err)
    end

    it 'creates a new host report' do
      api_expects(:host_reports, :create).with_params(
        'host_report' => {
          'reported_at' => '01/12/2021', 'host' => 'new.example.com',
          'body' => '""', 'change' => 5, 'format' => 'ansible', 'nochange' => 2,
          'failure' => 1
        }
      ).returns(new_host_report)

      expected_result = success_result("Host report created.\n")

      result = run_cmd(cmd + params)
      assert_cmd(expected_result, result)
    end
  end

  describe 'info' do
    let(:cmd) { %w[host-report info] }
    let(:params) { ['--id=1'] }
    let(:body) do
      {
        'environment' => 'Development',
        'format' => 'puppet',
        'logs' => [
          %w[notice resource message],
          %w[err resource message]
        ]
      }
    end
    let(:full_host_report) do
      {
        id: 1,
        host_id: 1,
        host_name: 'full.example.com',
        proxy_id: 1,
        proxy_name: 'proxy.example.com',
        format: 'puppet',
        reported_at: '01/12/2021',
        body: body.to_json,
        change: 5,
        failure: 1,
        nochange: 2,
        keywords: %w[HasChange PuppetHasChange]
      }
    end

    it 'shows the host report' do
      api_expects(:host_reports, :show, 'Show host report').with_params(
        'id' => '1'
      ).returns(full_host_report.transform_keys(&:to_s))

      output = OutputMatcher.new(
        [
          'Id:                 1',
          'Host:               full.example.com',
          'Host id:            1',
          'Proxy:              proxy.example.com',
          'Proxy id:           1',
          'Keywords:           HasChange, PuppetHasChange',
          'Reported at:        2021/12/01 00:00:00',
          'Format:             Puppet',
          'Puppet environment: Development',
          'Summary:',
          '    Change:    5',
          '    No change: 2',
          '    Failure:   1',
          'Logs:',
          ' 1) Level:    notice',
          '    Resource: resource',
          '    Message:  message',
          ' 2) Level:    err',
          '    Resource: resource',
          '    Message:  message'
        ]
      )

      expected_result = success_result(output)

      result = run_cmd(cmd + params)
      assert_cmd(expected_result, result)
    end
  end

  describe 'delete' do
    let(:cmd) { %w[host-report delete] }
    let(:params) { ['--id=1'] }
    it 'deletes the host report' do
      api_expects(:host_reports, :destroy, 'Delete host report').with_params(
        'id' => '1'
      )

      expected_result = success_result("Host report deleted.\n")

      result = run_cmd(cmd + params)
      assert_cmd(expected_result, result)
    end
  end
end
