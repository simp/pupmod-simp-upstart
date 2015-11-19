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
    $main_process = '',
    $pre_start_type = 'exec',
    $pre_start = '',
    $post_start_type = 'exec',
    $post_start = '',
    $pre_stop_type = 'exec',
    $pre_stop = '',
    $post_stop_type = 'exec',
    $post_stop = '',
    $stop_on = '',
    $default_env = '',
    $env_export = '',
    $is_task = false,
    $respawn = false,
    $respawn_limit = '',
    $normal_exit = '',
    $instance_name = '',
    $description = '',
    $author = '',
    $doc_version = '',
    $emits = '',
    $console = '',
    $umask = '022',
    $nice = '',
    $oom = '',
    $chroot = '',
    $chdir = '',
    $sys_limit = '',
    $kill_timeout = '',
    $expect_stop = false,
    $expect_daemon = false,
    $expect_fork = false
) {

  validate_string($start_on)
  validate_re($main_process_type,'^(exec|script)$')
  unless empty($main_process) { validate_string($main_process) }
  validate_re($pre_start_type,'^(exec|script)$')
  unless empty($pre_start) { validate_string($pre_start) }
  validate_re($post_start_type,'^(exec|script)$')
  unless empty($post_start) { validate_string($post_start) }
  validate_re($pre_stop_type,'^(exec|script)$')
  unless empty($pre_stop) { validate_string($pre_stop) }
  validate_re($post_stop_type,'^(exec|script)$')
  unless empty($post_stop) { validate_string($post_stop) }
  unless empty($stop_on) { validate_string($stop_on) }
  unless empty($default_env) { validate_string($default_env) }
  unless empty($env_export) { validate_string($env_export) }
  validate_bool($is_task)
  validate_bool($respawn)
  unless empty($respawn_limit) { validate_integer($respawn_limit) }
  unless empty($normal_exit) { validate_string($normal_exit) }
  unless empty($instance_name) { validate_string($instance_name) }
  unless empty($description) { validate_string($description) }
  unless empty($author) { validate_string($author) }
  unless empty($doc_version) { validate_string($doc_version) }
  unless empty($emits) { validate_string($emits) }
  unless empty($console) {
    validate_string($console)
    validate_console($console)
  }
  validate_umask($umask)
  unless empty($nice) { validate_string($nice) }
  unless empty($oom) { validate_integer($oom) }
  unless empty($chroot) { validate_string($chroot) }
  unless empty($chdir) { validate_string($chdir) }
  unless empty($sys_limit) {
    validate_re($sys_limit,'^(core|cpu|data|fsize|memlock|msgqueue|nice|nofile|nproc|rss|rtprio|sigpending|stack)(\s+\d+|\s+unlimited){2}$')
    validate_sys_limit($sys_limit)
  }
  unless empty($kill_timeout) { validate_integer($kill_timeout) }
  validate_bool($expect_stop)
  validate_bool($expect_daemon)
  validate_bool($expect_fork)

  unless empty($main_process_type) { validate_process_types($main_process_type) }
  unless empty($pre_start_type) { validate_process_types($pre_start_type) }
  unless empty($post_start_type) { validate_process_types($post_start_type) }
  unless empty($pre_stop_type) { validate_process_types($pre_stop_type) }
  unless empty($post_stop_type) { validate_process_types($post_stop_type) }

  file { "/etc/init/${name}.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('upstart/job.erb')
  }

}
