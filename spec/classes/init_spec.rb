require 'spec_helper'

describe 'upstart' do

  it { should create_class('upstart') }
  base_facts = {
    :operatingsystem => 'RedHat',
    :lsbmajdistrelease => '7'
  }
  let(:facts){base_facts}

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
