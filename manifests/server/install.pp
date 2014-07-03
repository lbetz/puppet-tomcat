# == private Define Resource: tomcat::server::install
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::install {

   $basedir         = "${tomcat::basedir}/${title}"
   $owner           = $params::owner
   $group           = $params::group

   file { $basedir:
      ensure => directory,
      owner  => 'root',
      group  => 'wheel',
      mode   => '0755',
   }
   
   file { "${basedir}/logs":
      ensure => directory,
      owner  => $owner,
      group  => 'root',
      mode   => '0755',
   }

   file { ["${basedir}/temp", "${basedir}/work", "${basedir}/webapps"]:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0775',
   }
   
   file { "${basedir}/bin":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }

   file { "${basedir}/conf":
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '2775',
   }

   file { "${basedir}/lib":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }

   #file { "${basedir}/private":
   #   ensure => directory,
   #   owner  => 'root',
   #   group  => $group,
   #   mode   => '2770',
   #}

}
