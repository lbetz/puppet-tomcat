define tomcat::server::service(
   $ensure = running,
   $enable = true,
) {

   if $module_name != $caller_module_name {
      fail("tomcat::server::service is a private define resource of module tomcat, you're not able to use.")
   }

   $version = $tomcat::version
   $service = $params::conf[$version]['service']

   service { "${service}-${title}":
      ensure => $ensure,
      enable => $enable,
      hasstatus => false,
      pattern => "-Dcatalina.base=${tomcat::basedir}/${title}",
   }

}
