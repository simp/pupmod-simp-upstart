# == Define: upstart::job
#
# This define allows you to manage upstart jobs in /etc/init.
#
# See init(5) for more information.
#
# == Parameters
#
# All variables lacking comments come directly from init(5)
#
# [*name*]
#   The name of the job to be written. Do not use an absolute path!
#   The result will be /etc/init/${name}.conf
#
# [*main_process_type]
#   The type of the main process, may be one of 'exec' or 'script'.
#
# [*main_process*]
#   The content of the main process.
#
# [*pre_start_type*]
#   The type of the pre-start script, may be one of 'exec' or 'script'.
#
# [*pre_start*]
#   The content of the pre-start stanza
#
# [*post_start_type*]
#   The type of the post-start script, may be one of 'exec' or 'script'
#
# [*post_start*]
#   The content of the post-start stanza
#
# [*pre_stop_type*]
#   The type of the pre-stop script, may be one of 'exec' or 'script'
#
# [*pre_stop*]
#   The content of the pre-stop stanza
#
# [*post_stop_type*]
#   The type of the post-stop script, may be one of 'exec' or 'script'
#
# [*post_stop*]
#   The content of the post-stop stanza
#
# [*default_env*]
#   Corresponds to the 'env' keyword.
#
# [*env_export*]
#   Corresponds to the 'export' keyword.
#
# [*is_task*]
#   Corresponds to the 'task' keyword.
#
# [*respawn_limit*]
#   An array containing two integers corresponding to 'count' and 'interval'
#   for the 'respawn limit' keyword.
#
# [*normal_exit*]
#   An array of exit statuses and/or signals that indicate tat the job has
#   terminated successfully.
#
# [*instance_name*]
#   The 'instance' keyword
#
# [*doc_version*]
#   Maps to the 'version' keyword.
#
# [*emits*]
#   An array of arbitrary events to emit.
#
# [*sys_limit*]
#   Maps to the 'limit' keyword.
#   Accepts a three item array of values ehat should be 'LIMIT','SOFT', and
#   'HARD' respectively.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
define upstart::job (
    $start_on,
    $main_process_type = 'exec',
    $main_process = 'nil',
    $pre_start_type = 'exec',
    $pre_start = 'nil',
    $post_start_type = 'exec',
    $post_start = 'nil',
    $pre_stop_type = 'exec',
    $pre_stop = 'nil',
    $post_stop_type = 'exec',
    $post_stop = 'nil',
    $stop_on = 'nil',
    $default_env = 'nil',
    $env_export = 'nil',
    $is_task = false,
    $respawn = false,
    $respawn_limit = 'nil',
    $normal_exit = 'nil',
    $instance_name = 'nil',
    $description = 'nil',
    $author = 'nil',
    $doc_version = 'nil',
    $emits = 'nil',
    $console = 'nil',
    $umask = '022',
    $nice = 'nil',
    $oom = 'nil',
    $chroot = 'nil',
    $chdir = 'nil',
    $sys_limit = 'nil',
    $kill_timeout = 'nil',
    $expect_stop = false,
    $expect_daemon = false,
    $expect_fork = false
) {

  file { "/etc/init/${name}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('upstart/job.erb')
  }

  validate_string($start_on)
  validate_re($main_process_type,'^(exec|script)$')
  if $main_process != 'nil' { validate_string($main_process) }
  validate_re($pre_start_type,'^(exec|script)$')
  if $pre_start != 'nil' { validate_string($pre_start) }
  validate_re($post_start_type,'^(exec|script)$')
  if $post_start != 'nil' { validate_string($post_start) }
  validate_re($pre_stop_type,'^(exec|script)$')
  if $pre_stop != 'nil' { validate_string($pre_stop) }
  validate_re($post_stop_type,'^(exec|script)$')
  if $post_stop != 'nil' { validate_string($post_stop) }
  if $stop_on != 'nil' { validate_string($stop_on) }
  if $default_env != 'nil' { validate_string($default_env) }
  if $env_export != 'nil' { validate_string($env_export) }
  validate_bool($is_task)
  validate_bool($respawn)
  if $respawn_limit != 'nil' { validate_integer($respawn_limit) }
  if $normal_exit != 'nil' { validate_string($normal_exit) }
  if $instance_name != 'nil' { validate_string($instance_name) }
  if $description != 'nil' { validate_string($description) }
  if $author != 'nil' { validate_string($author) }
  if $doc_version != 'nil' { validate_string($doc_version) }
  if $emits != 'nil' { validate_string($emits) }
  if $console != 'nil' { validate_string($console) }
  validate_umask($umask)
  if $nice != 'nil' { validate_string($nice) }
  if $oom != 'nil' { validate_integer($oom) }
  if $chroot != 'nil' { validate_string($chroot) }
  if $chdir != 'nil' { validate_string($chdir) }
  if $sys_limit != 'nil' { validate_re($sys_limit,'^(core|cpu|data|fsize|memlock|msgqueue|nice|nofile|nproc|rss|rtprio|sigpending|stack)(\s+\d+|\s+unlimited){2}$') }
  if $kill_timeout != 'nil' { validate_integer($kill_timeout) }
  validate_bool($expect_stop)
  validate_bool($expect_daemon)
  validate_bool($expect_fork)
}
