require 'spec_helper'

describe 'upstart' do

  context 'supported operating systems' do

    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          facts = os_facts.dup
          if ['RedHat','CentOS'].include?(os_facts[:operatingsystem]) &&
             (os_facts[:operatingsystemmajrelease].to_s < '7')

            facts[:apache_version] = '2.2'
            facts[:grub_version] = '0.9'
            facts[:uid_min] = '500'
          else
            facts[:apache_version] = '2.4'
            facts[:grub_version] = '2.0~beta'
            facts[:uid_min] = '1000'
          end

          facts
        end

        context 'with default parameters' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_class('upstart') }
          it { is_expected.to_not contain_auditd__add_rules('upstart') }

          it do
            is_expected.to contain_file('/etc/init').with({
              'ensure' => 'directory',
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0644'
            })
          end

          it do
            is_expected.to contain_upstart__job('control-alt-delete').with({
              'main_process' => '/bin/logger -p local6.warning "Ctrl-Alt-Del was pressed"',
              'start_on'     => 'control-alt-delete',
              'description'  => 'Logs that Ctrl-Alt-Del was pressed without rebooting the system.'
            })
          end
        end

        context 'with auditing enabled' do
          let(:params) {{ :auditd => true }}
          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_auditd__add_rules('upstart').with({
              'content' => '-w /etc/init/ -p wa -k CFG_upstart'
            })
          end
        end

        context 'with disable_ctrl_alt_del false' do
          let(:params) {{ :disable_ctrl_alt_del => false }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to_not contain_upstart__job('control-alt-delete') }
        end
      end
    end
  end
end
