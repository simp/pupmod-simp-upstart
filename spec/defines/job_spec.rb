require 'spec_helper'

describe 'upstart::job' do

  let(:title) { 'control-alt-delete' }

  context 'with default parameters' do
    let(:params) { {:start_on => 'control-alt-delete'} }

    it { is_expected.to compile.with_all_deps }
    it do
      is_expected.to contain_file('/etc/init/control-alt-delete.conf').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0640',
        'content' => <<EOM
# This file managed by Puppet
# Changes will be overwritten on the next Puppet run.
#

start on control-alt-delete
umask 022
EOM
      })
    end
  end

  context 'with optional parameters set' do
    let(:params) { {
      :start_on      => 'control-alt-delete',
      :main_process  => '/bin/logger -p local6.warning "Ctrl-Alt-Del was pressed"',
      :pre_start     => '/some/pre/start/exe',
      :post_start    => '/some/post/start/exe',
      :pre_stop      => '/some/pre/stop/exe',
      :post_stop     => '/some/pre/stop/exe',
      :stop_on       => 'device-removed DEVPATH=$DEVPATH',
      :default_env   => 'KEY1=value1',
      :env_export    => 'KEY1',
      :respawn_limit => [9, 4],
      :normal_exit   => ['0', '1', 'TERM','HUP'],
      :instance_name => 'some instance name',
      :description   => 'some description',
      :author        => 'Author Bob',
      :doc_version   => '1.2-3x',
      :emits         => ['starting', 'stopping'],
      :console       => 'output',
      :nice          => 10,
      :oom           => 'never',
      :chroot        => '/var/some/chroot',
      :chdir         => '/my/root/dir',
      :sys_limit     => ['core', '3', '5'],
      :kill_timeout  => 10
    } }

    it { is_expected.to compile.with_all_deps }
    it do
      is_expected.to contain_file('/etc/init/control-alt-delete.conf').with({
        'content' => <<EOM
# This file managed by Puppet
# Changes will be overwritten on the next Puppet run.
#

exec /bin/logger -p local6.warning "Ctrl-Alt-Del was pressed"
pre-start exec /some/pre/start/exe
post-start exec /some/post/start/exe
pre-stop exec /some/pre/stop/exe
post-stop exec /some/pre/stop/exe
start on control-alt-delete
stop on device-removed DEVPATH=$DEVPATH
env KEY1=value1
export KEY1
respawn limit 9 4
normal exit 0 1 TERM HUP
instance some instance name
description "some description"
author "Author Bob"
version "1.2-3x"
emits starting stopping
console output
umask 022
nice 10
oom never
chroot /var/some/chroot
chdir /my/root/dir
limit core 3 5
kill timeout 10
EOM
      })
    end
  end

  context 'with script process types and default booleans inverted' do
    let(:main_script) {<<EOM
export HOME="/srv"
echo $$ > /var/run/nodetest.pid
exec /usr/bin/nodejs /srv/nodetest.js
EOM
    }

    let(:script_template) {<<EOM
echo "[`date`] Node Test STATE" >> /var/log/nodetest.log
EOM
    }
    
    let(:params) { {
      :start_on           => 'control-alt-delete',
      :main_process_type  => 'script',
      :main_process       => main_script,
      :pre_start_type     => 'script',
      :pre_start          => script_template.gsub('STATE', 'Starting'),
      :post_start_type    => 'script',
      :post_start         => script_template.gsub('STATE', 'Started'),
      :pre_stop_type      => 'script',
      :pre_stop           => "rm /var/run/nodetest.pid\n" + 
        script_template.gsub('STATE', 'Stopping'),
      :post_stop_type     => 'script',
      :post_stop          => script_template.gsub('STATE', 'Stopped'),
      :is_task            => true,
      :respawn            => true,
      :expect_stop        => true,
      :expect_daemon      => true,
      :expect_fork        => true
    } }

    it { is_expected.to compile.with_all_deps }
    it do
      is_expected.to contain_file('/etc/init/control-alt-delete.conf').with({
        'content' => <<EOM
# This file managed by Puppet
# Changes will be overwritten on the next Puppet run.
#

script
  export HOME="/srv"
  echo $$ > /var/run/nodetest.pid
  exec /usr/bin/nodejs /srv/nodetest.js
end script

pre-start script
  echo "[`date`] Node Test Starting" >> /var/log/nodetest.log
end script

post-start script
  echo "[`date`] Node Test Started" >> /var/log/nodetest.log
end script

pre-stop script
  rm /var/run/nodetest.pid
  echo "[`date`] Node Test Stopping" >> /var/log/nodetest.log
end script

post-stop script
  echo "[`date`] Node Test Stopped" >> /var/log/nodetest.log
end script

start on control-alt-delete
task
respawn
umask 022
expect stop
expect daemon
expect fork
EOM
      })
    end
  end

  context 'with invalid limit in sys_limit' do
    let(:params) { { :sys_limit     => ['oops', '3', '5'] } }
    it { is_expected.to_not compile.with_all_deps }
  end

end
