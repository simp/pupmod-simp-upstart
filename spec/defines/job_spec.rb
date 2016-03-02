require 'spec_helper'

describe 'upstart::job' do

  let(:title) { 'control-alt-delete' }

  let(:params) { {:start_on => 'control-alt-delete'} }

  it do
    is_expected.to contain_file('/etc/init/control-alt-delete.conf').with({
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0640',
      'content' => /start on control-alt-delete/
    })
  end

end
