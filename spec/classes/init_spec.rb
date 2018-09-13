require 'spec_helper'

describe 'upstart' do

  context 'supported operating systems' do

    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          facts = os_facts.dup
          if ['RedHat','CentOS','OracleLinux'].include?(os_facts[:operatingsystem]) &&
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
          it { is_expected.to_not contain_auditd__rule('upstart') }

          it do
            is_expected.to contain_file('/etc/init').with({
              'ensure' => 'directory',
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0644'
            })
          end
        end

        context 'with auditing enabled' do
          let(:params) {{ :auditd => true }}
          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_auditd__rule('upstart').with({
              'content' => '-w /etc/init/ -p wa -k CFG_upstart'
            })
          end
        end
      end
    end
  end
end
