define tomcat::server::initialize(
   $ensure = 'present',
   $java_home,
   $setenv,
) {

   $version         = $tomcat::version
   $catalina_home   = $params::config[$version]['catalina_home']
   $catalina_script = $params::config[$version]['catalina_script']
   $server          = $title
   $basedir         = "${tomcat::basedir}/${server}"
   $owner           = $params::owner

   file { "/etc/init.d/tomcat-${title}":
      ensure => $ensure ? {
         absent  => 'absent',
         default => file,
      },
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      content => template('tomcat/tomcat.init.erb'),
   }

   file { "${basedir}/bin/setenv.sh":
      ensure  => file,
      owner   => $owner,
      group   => 'adm',
      mode    => '0570',
      content => template('tomcat/setenv.sh.erb'),
   }

   file { "${basedir}/bin/setenv-local.sh":
      ensure  => file,
      owner   => $owner,
      group   => 'adm',
      mode    => '0570',
   }

}
