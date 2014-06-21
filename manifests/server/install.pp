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
      group  => $group,
      mode   => '0555',
   }
   
   file { ["${basedir}/logs", "${basedir}/temp", "${basedir}/work", "${basedir}/webapps"]:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => '0755',
   }
   
   file { "${basedir}/bin":
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0755',
   }

   file { "${basedir}/conf":
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => '2570',
   }

   file { "${basedir}/lib":
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '2775',
   }

   file { "${basedir}/private":
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '2770',
   }

}
