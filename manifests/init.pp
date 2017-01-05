# This class allows you to configure the upstart init files
#
# Unless otherwise noted, the variables passed to this class set up
# ``/etc/sysconfig/init``
#
# This *only* sets security-relevant options. You'll need to use the augeas
# provider to prod different values in the target file but this provides a good
# example.
#
# @see init(8)
#
# @param auditd
#   If true, includes SIMP's ::auditd class and then adds upstart audit rule
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class upstart (
  Boolean $auditd               = simplib::lookup('simp_options::auditd', { 'default_value' => false })
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
}
