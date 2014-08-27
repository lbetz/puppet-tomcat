# == private Define Resource: tomcat::server::install
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::install {

   if $module_name != $caller_module_name {
      fail("tomcat::server::install is a private define resource of module tomcat, you're not able to use.")
   }

   $owner   = $params::owner
   $group   = $params::group
   $version = $tomcat::version

   # standalone
   if $tomcat::config {
      $tempdir   = $params::conf[$version]['tempdir']
      $workdir   = $params::conf[$version]['workdir']
      $webappdir = $params::conf[$version]['webappdir']
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

   file { [$tempdir, $workdir, $webappdir]:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0775',
   }

}
