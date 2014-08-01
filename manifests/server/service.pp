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
#   Enable (true, default) or disable (false) the service to start at boot.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>

define tomcat::server::service(
   $ensure = 'running',
   $enable = true,
) {

   if $module_name != $caller_module_name {
      fail("tomcat::server::service is a privat define resource of module tomcat, you're not able to use.")
   }

   # standalone
   if $tomcat::config {
      $service = $tomcat::service
   }
   # multi instance
   else {
      $service = "tomcat-${title}"
   }

   service { $service:
      ensure => $ensure ? {
         absent   => 'stopped',
         stopped  => 'stopped',
         default  => 'running',
      },
      enable => $enable,
   }

}
