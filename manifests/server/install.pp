# == private Define Resource: tomcat::server::install
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::install {

   $owner   = $params::owner
   $group   = $params::group
   $version = $tomcat::version

   # standalone
   if $tomcat::config {
      $basedir   = $params::conf[$version]['catalina_home']
      $logdir    = $params::conf[$version]['logdir']
      $tempdir   = $params::conf[$version]['tempdir']
      $workdir   = $params::conf[$version]['workdir']
      $webappdir = $params::conf[$version]['webappdir']
      $bindir    = $params::conf[$version]['bindir']
      $confdir   = $params::conf[$version]['confdir']
      $libdir    = $params::conf[$version]['libdir']
   }
   # multi instance
   else {
      $basedir   = "${tomcat::basedir}/${title}"
      $logdir    = "${basedir}/logs"
      $tempdir   = "${basedir}/temp"
      $workdir   = "${basedir}/work"
      $webappdir = "${basedir}/webapps"
      $bindir    = "${basedir}/bin"
      $confdir   = "${basedir}/conf"
      $libdir    = "${basedir}/lib"
   }

   file { $basedir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }
   
   file { $logdir:
      ensure => directory,
      owner  => $owner,
      group  => 'root',
      mode   => '0755',
   }

   file { [$tempdir, $workdir, $webappdir]:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0775',
   }
   
   file { $bindir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }

   file { $confdir:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '2775',
   }

   file { $libdir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }

}
