# == private Define Resource: tomcat::server::initialize
#
# Full description of define tomcat::server::initialize here.
#
# === Parameters
#
# Document parameters here.
#
# [*user*]
#   user context for running of this instance.
#
# [*group*]
#   same for group
#
# [*java_home*]
#   java_home directory where to find the java binary
#
# [*setenv*]
#   Handles environment variables in sysconfig file.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::initialize(
  $user,
  $group,
  $java_home,
  $setenv,
) {

  if $module_name != $caller_module_name {
    fail("tomcat::server::initialize is a private define resource of module tomcat, you're not able to use.")
  }

  $version       = $tomcat::version
  $service       = $params::conf[$version]['service']
  $basedir       = "${tomcat::basedir}/${title}"
  $sysconfig     = "${params::conf[$version]['sysconfig']}-${title}"
  $catalina_home = $params::conf[$version]['catalina_home']
  $catalina_base = $basedir
  $catalina_pid  = "${params::conf[$version]['catalina_pid']}-${title}"
  $tempdir       = "${basedir}/temp"
  $logdir        = "${basedir}/logs"

  file { $sysconfig:
    ensure  => file,
    owner   => 'root',
    group   => $group,
    mode    => '0664',
    content => template('tomcat/sysconfig.erb'),
  }

  file { $catalina_pid:
    ensure => file,
    owner  => $user,
    group  => $group,
    mode   => '0644',
  }

}
