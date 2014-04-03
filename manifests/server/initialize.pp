define tomcat::server::initialize(
   $java_home,
) {

   $version         = $tomcat::version
   $catalina_home   = $params::config[$version]['catalina_home']
   $catalina_script = $params::config[$version]['catalina_script']
   $server          = $title
   $basedir         = "${tomcat::basedir}/${server}"
   $owner           = $params::owner

   file { "/etc/init.d/tomcat-${title}":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      content => template('tomcat/tomcat.init.erb'),
   }

}
