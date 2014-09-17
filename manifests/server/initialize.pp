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

   if $tomcat::standalone {
      $sysconfig     = $params::conf[$version]['sysconfig']
      $catalina_home = $params::conf[$version]['catalina_home']
      $catalina_base = $catalina_home
      $catalina_pid  = $params::conf[$version]['catalina_pid']
      $tempdir       = $params::conf[$version]['tempdir']
   } else {
      $basedir       = "${tomcat::basedir}/${title}"
      $sysconfig     = "${params::conf[$version]['sysconfig']}-${title}"
      $catalina_home = $params::conf[$version]['catalina_home']
      $catalina_base = $basedir
      $catalina_pid  = "${params::conf[$version]['catalina_pid']}-${title}"
      $tempdir       = "${basedir}/temp"
   }

   file { $sysconfig:
      ensure  => file,
      owner   => 'root',
      group   => $group,
      mode    => '0664',
      content => template('tomcat/tomcat6.erb'),
   }

}
