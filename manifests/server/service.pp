# == private Define Resource: tomcat::server::service
#
# Full description of define tomcat::server::service here.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   present or running (present), stopped
#
# [*enable*]
#   Enables or disableis the service to start at boot.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::service(
   $ensure,
   $enable,
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
