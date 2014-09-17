define tomcat::server::install(
   $user,
   $group,
) {

   if $module_name != $caller_module_name {
      fail("tomcat::server::install is a private define resource of module tomcat, you're not able to use.")
   }

   $basedir       = "${tomcat::basedir}/${title}"
   $version       = $tomcat::version
   $initd         = $params::conf[$version]['initd']

   file { [$basedir, "${basedir}/bin", "${basedir}/lib", "${basedir}/webapps", "${basedir}/work"]:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }

   file { "${basedir}/conf":
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0775',
   }

   file { ["${basedir}/logs", "${basedir}/temp"]:
      ensure => directory,
      owner  => $user,
      group  => 'root',
      mode   => '0755',
   }

   file { "${initd}-${title}":
      ensure => symlink,
      target => $initd
   }

}
