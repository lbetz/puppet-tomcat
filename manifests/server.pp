define tomcat::server(
   $ensure    = 'running',
   $enable    = true,
   $listeners = {},
   $port      = '8005',
   $resources = {},
   $services  = {},
   $java_home = '/usr/lib/jvm/jre',
) {

   validate_re($ensure, '^(present|absent|running|stopped)$',
      "${ensure} is not supported for ensure. Allowed values are 'present', 'absent', 'running' and 'stopped'.")
   validate_bool($enable)

   require tomcat

   if $ensure != 'absent' {
      tomcat::server::install { $title: } ->
      tomcat::server::config { $title:
         port      => $port,
         services  => $services,
         resources => $resources,
         listeners => $listeners,
         java_home => $java_home,
      } ~>
      tomcat::server::service { $title:
         ensure => $ensure,
         enable => $enable,
      }
   }
   else {
      tomcat::server::service { $title:
         ensure => stopped,
         enable => false,
      } ->
      file { "${tomcat::basedir}/${title}":
         ensure  => absent,
         recurse => true,
         force   => true,
      }
   }
   
}
