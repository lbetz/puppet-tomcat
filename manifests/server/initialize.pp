# == private Define Resource: tomcat::server::initialize
#
# Full description of define tomcat::server::initialize here.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   present or running (present), stopped
#
# [*java_home*]
#   java_home directory where to find the java binary
#
# [*setenv*]
#   Handles environment variables in 'bin/setenv-local.sh'.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::initialize(
   $ensure = 'present',
   $java_home,
   $setenv,
) {

   if $module_name != $caller_module_name {
      fail("tomcat::server::initialize is a private define resource of module tomcat, you're not able to use.")
   }

   # used by init script
   $version         = $tomcat::version
   $catalina_home   = $params::conf[$version]['catalina_home']
   $catalina_script = $params::conf[$version]['catalina_script']
   $server          = $title
   $owner           = $params::conf[$version]['owner']
   $group           = $params::conf[$version]['group']

   # standalone
   if $tomcat::config {
      $basedir = $params::conf[$version]['catalina_home']
      $bindir  = $params::conf[$version]['bindir']
      $initd   = $title
   }
   # multi instance
   else {
      $basedir = "${tomcat::basedir}/${title}"
      $bindir  = "${basedir}/bin"
      $initd   = "tomcat-${title}"
   }

   file { "/etc/init.d/${initd}":
      ensure => $ensure ? {
         absent  => 'absent',
         default => file,
      },
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      content => template('tomcat/tomcat.init.erb'),
   }

   if $ensure != 'absent' {
      file { "${bindir}/setenv.sh":
         ensure  => file,
         owner   => $owner,
         group   => $group,
         mode    => '0570',
         content => template('tomcat/setenv.sh.erb'),
      }

      file { "${bindir}/setenv-local.sh":
         ensure  => file,
         owner   => $owner,
         group   => $group,
         mode    => '0570',
      }
   }
}
