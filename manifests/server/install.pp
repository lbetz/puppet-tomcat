define tomcat::server::install {

   $basedir         = "${tomcat::basedir}/${title}"
   $owner           = $params::owner

   file { $basedir:
      ensure => directory,
      group  => 'adm',
      mode   => '0555',
   }
   
   file { ["${basedir}/logs", "${basedir}/temp", "${basedir}/work", "${basedir}/webapps"]:
      ensure => directory,
      owner  => $owner,
      group  => 'adm',
      mode   => '0755',
   }
   
   file { "${basedir}/bin":
      ensure => directory,
      owner  => 'root',
      group  => 'adm',
      mode   => '0755',
   }

   file { "${basedir}/conf":
      ensure => directory,
      owner  => $owner,
      group  => 'adm',
      mode   => '2570',
   }

   file { ["${basedir}/lib", "${basedir}/private"]:
      ensure => directory,
      owner  => 'root',
      group  => 'adm',
      mode   => '2770',
   }

}
