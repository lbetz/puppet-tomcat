# == Define Resource: tomcat::server
#
# Full description of define tomcat::server here.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   present or running (present), stopped
#
# [*enable*]
#   Enables (true, default) or disables (false) the service to start at boot.
#
# [*user*]
#   user context for running of this instance.
#
# [*group*]
#   same for group
#
# [*port*]
#   Management port (default 8005) on localhost for this instance.
#
# [*listeners*]
#   Hash of listeners in the global server section (server.xml).
#
# [*resources*]
#   Hash of global resources in the server section (server.xml).
#
# [*services*]
#   Hash of services and their attributes.
#
# [*java_home*]
#   java_home directory where to find the java binary
#
# [*setenv*]
#   Handles environment variables in sysconfig file.
#
# [*manage*]
#    Enables (default) the configuration of server.xml by this module. Disable means, that
#    you have to manage the configuration outside and notify the service.
#
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server(
   $ensure    = running,
   $enable    = true,
   $user      = undef,
   $group     = undef,
   $port      = '8005',
   $listeners = undef,
   $resources = undef,
   $services  = undef,
   $java_home = undef,
   $setenv    = [],
   $manage    = true,
) {

   require tomcat

   if $tomcat::standalone {
      fail('Your using tomcat as standalone server')
   }

   validate_re($ensure, '^(present|absent|running|stopped)$',
      "${ensure} is not supported for ensure. Valid values are 'present', 'absent', 'running' and 'stopped'.")
   validate_bool($enable)
   validate_bool($manage)

   $version   = $params::version
   $initd     = "${params::conf[$version]['initd']}-${title}"
   $sysconfig = "${params::conf[$version]['sysconfig']}-${title}"
   $basedir   = "${tomcat::basedir}/${title}"

   # set prameter defaults
   if $listeners {
      validate_hash($listeners)
      $_listeners = $listeners }
   else {
      $_listeners = $tomcat::listeners
   }
   if $services {
      validate_hash($services)
      $_services = $services }
   else {
      $_services = $tomcat::services
   }
   if $resources {
      validate_hash($resources)
      $_resources = $resources }
   else {
      $_resources = $tomcat::resources
   }
   if $java_home {
      validate_absolute_path($java_home)
      $_java_home = $java_home }
   else {
      $_java_home = $tomcat::java_home
   }
   if $user { $_user = $user } else { $_user = $tomcat::user }
   if $group { $_group = $group } else { $_group = $tomcat::group }

   if $ensure != 'absent' {
      tomcat::server::install { $title:
         user  => $_user,
         group => $_group,
      }
      -> anchor { "tomcat::server::${title}::begin":
         notify => Tomcat::Server::Service[$title],
      }
      -> tomcat::server::initialize { $title:
         user      => $_user,
         group     => $_group,
         java_home => $_java_home,
         setenv    => $setenv,
         notify    => Tomcat::Server::Service[$title],
      }
      -> tomcat::server::config { $title:
         user      => $_user,
         group     => $_group,
         port      => $port,
         services  => $_services,
         resources => $_resources,
         listeners => $_listeners,
         manage    => $manage,
      }
      ~> tomcat::server::service { $title:
         ensure => $ensure,
         enable => $enable,
      }
      -> anchor { "tomcat::server::${title}::end": }
   }
   else {
      anchor { "tomcat::server::${title}::begin": }
      -> tomcat::server::service { $title:
         ensure => stopped,
         enable => false,
      } ->
      file { [$initd, $sysconfig]:
         ensure => absent,
      } ->
      file { $basedir:
         ensure  => absent,
         recurse => true,
         force   => true,
      } ->
      anchor { "tomact::server::${title}::end": }
   }

}
