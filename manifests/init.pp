# == Class: upstart
#
# This class allows you to configure the upstart init files.
#
# == Parameters
#
# Unless otherwise noted, the variables passed to this class set up
# /etc/sysconfig/init
#
# This *only* sets security-relevant options. You'll need to use the augeas
# provider to prod different values in the target file but this provides a good
# example.
#
# See init(8) for more information.
#
# @param auditd
#   If true, includes SIMP's ::auditd class and then adds upstart audit rule
#
# @param disable_ctrl_alt_del
#   If true, do not restart the system when ctrl-alt-del is pressed. Instead,
#   log the keypress to the system log at level local6.warning.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class upstart (
  Boolean $auditd               = simplib::lookup('simp_options::auditd', { 'default_value' => false }),
  Boolean $disable_ctrl_alt_del = true
) {

  if $auditd {
    include '::auditd'
    auditd::add_rules { 'upstart':
      content => '-w /etc/init/ -p wa -k CFG_upstart'
    }
  }

  file { '/etc/init':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  if $disable_ctrl_alt_del {
    upstart::job { 'control-alt-delete':
      main_process => '/bin/logger -p local6.warning "Ctrl-Alt-Del was pressed"',
      start_on     => 'control-alt-delete',
      description  => 'Logs that Ctrl-Alt-Del was pressed without rebooting the system.'
    }
  }

}
