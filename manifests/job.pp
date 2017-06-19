# This define allows you to manage upstart jobs in /etc/init.
#
# See init(5) for more information.
# All variables lacking comments come directly from init(5)
#
# @attr name  The name of the job to be written. Do not use an absolute
#   path! The result will be /etc/init/${name}.conf
#
# @param start_on  The set of events that will cause the job to be
#   automatically started.
#
# @param main_process_type  The type of the main process, may be one of
#   'exec' or 'script'.
#
# @param main_process  The content of the main process.
#
# @param pre_start_type  The type of the pre-start script, may be one of
#   'exec' or 'script'.
#
# @param pre_start  The content of the pre-start stanza.
#
# @param post_start_type  The type of the post-start script, may be one
#   of 'exec' or 'script'
#
# @param post_start  The content of the post-start stanza.
#
# @param pre_stop_type  The type of the pre-stop script, may be one of
#   'exec' or 'script'
#
# @param pre_stop  The content of the pre-stop stanza.
#
# @param post_stop_type  The type of the post-stop script, may be one of
#   'exec' or 'script'
#
# @param post_stop  The content of the post-stop stanza.
#
# @param stop_on  The set of events that will cause the job to be
#   automatically stopped.
#
# @param default_env  Corresponds to the 'env' keyword.
#
# @param env_export  Corresponds to the 'export' keyword.
#
# @param is_task  Corresponds to the 'task' keyword.
#
# @param respawn_limit  An array containing two integers corresponding to
#   'count' and 'interval' for the 'respawn limit' keyword.
#
# @param normal_exit  An array of exit statuses and/or signals that
#   indicate tat the job has terminated successfully.
#
# @param instance_name  The 'instance' keyword.
#
# @param description The description of the job.
#
# @aparm author The author of the job.
#
# @param doc_version  The jversion information about the job.  Maps to
#   the 'version' keyword.
#
# @param emits  An array of arbitrary events to emit.
#
# @param console Option to connect standard input, output, and error to
#   /dev/console. Value may be 'output' or 'owner'.
#
# @parm umask  The file mode creation mask for the process.
#
# @param nice  The process's nice value.
#
# @param oom  The OOM killer setting.
#
# @param chroot The directory underneath which the process will be run in a chroot.
#
# @param chdir  The directory to be the root of the chroot instead of
#   the root of the filesystem.
#
# @param sys_limit  Maps to the 'limit' keyword.  Accepts a three item
#   array of values that should be 'LIMIT','SOFT', and 'HARD' respectively.
#
# @param kill_timeout  The interval between sending the job's main process
#   the SIGTERM and SIGKILL signals when stopping the running job.
#
# @param expect_stop  Maps to 'expect stop'.
#
# @param expect_daemon  Maps to 'expect daemon'.
#
# @param expect_fork  Maps to 'expect fork'.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
define upstart::job (
    String                          $start_on,
    Upstart::Process                $main_process_type = 'exec',
    Optional[String]                $main_process      = undef,
    Upstart::Process                $pre_start_type    = 'exec',
    Optional[String]                $pre_start         = undef,
    Upstart::Process                $post_start_type   = 'exec',
    Optional[String]                $post_start        = undef,
    Upstart::Process                $pre_stop_type     = 'exec',
    Optional[String]                $pre_stop          = undef,
    Upstart::Process                $post_stop_type    = 'exec',
    Optional[String]                $post_stop         = undef,
    Optional[String]                $stop_on           = undef,
    Optional[String]                $default_env       = undef,
    Optional[String]                $env_export        = undef,
    Boolean                         $is_task           = false,
    Boolean                         $respawn           = false,
    Optional[Array[Integer,2,2]]    $respawn_limit     = undef,
    Optional[Array[String]]         $normal_exit       = undef,
    Optional[String]                $instance_name     = undef,
    Optional[String]                $description       = undef,
    Optional[String]                $author            = undef,
    Optional[String]                $doc_version       = undef,
    Optional[Array[String]]         $emits             = undef,
    Optional[Upstart::Console]      $console           = undef,
    String                          $umask             = '022',
    Optional[Integer]               $nice              = undef,
    Optional[String]                $oom               = undef,
    Optional[Stdlib::Absolutepath]  $chroot            = undef,
    Optional[Stdlib::Absolutepath]  $chdir             = undef,
    Optional[Array[String, 3, 3]]   $sys_limit         = undef,
    Optional[Integer]               $kill_timeout      = undef,
    Boolean                         $expect_stop       = false,
    Boolean                         $expect_daemon     = false,
    Boolean                         $expect_fork       = false
) {

  validate_umask($umask)
  if $sys_limit {
    upstart::validate_sys_limit($sys_limit)
  }
  #TODO add type for oom which can be number from -16 to 14 OR 'never'

  file { "/etc/init/${name}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('upstart/job.erb')
  }

}
