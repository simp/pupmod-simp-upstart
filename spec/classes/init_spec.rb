require 'spec_helper'

describe 'upstart' do

  context 'supported operating systems' do

    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          if ['RedHat','CentOS'].include?(facts[:operatingsystem]) &&
             (facts[:operatingsystemmajrelease].to_s < '7')

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

        it { should create_class('upstart') }
        it do
          should contain_auditd__add_rules('upstart').with({
            'content' => '-w /etc/init/ -p wa -k CFG_upstart'
          })
        end
      
        it do
          should contain_file('/etc/init').with({
            'ensure' => 'directory',
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644'
          })
        end
      end
    end
  end
end
