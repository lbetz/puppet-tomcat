define tomcat::server(
   $ensure    = 'running',
   $enable    = true,
   $listeners = {},
   $port      = '8005',
   $resources = {},
   $services  = {},
   $java_home = '/usr/lib/jvm/jre',
   $managed   = true,
   $setenv    = [],
) {

   validate_re($ensure, '^(present|absent|running|stopped)$',
      "${ensure} is not supported for ensure. Allowed values are 'present', 'absent', 'running' and 'stopped'.")
   validate_bool($enable)
   validate_hash($listeners)
   validate_hash($resources)
   validate_hash($services)
   validate_array($setenv)

   include concat::setup
   require tomcat

   if $ensure != 'absent' {
      tomcat::server::install { $title: } ->
      tomcat::server::initialize { $title:
         ensure    => present,
         java_home => $java_home,
         setenv    => $setenv,
      } ~>
      tomcat::server::service { $title:
         ensure => $ensure,
         enable => $enable,
      }

      if $managed {
         tomcat::server::config { $title:
            port      => $port,
            services  => $services,
            resources => $resources,
            listeners => $listeners,
            require   => Tomcat::Server::Initialize[$title],
            notify    => Tomcat::Server::Service[$title],
         }
      }

   }
   else {
      tomcat::server::service { $title:
         ensure => stopped,
         enable => false,
      } ->
      tomcat::server::initialize { $title:
         ensure => absent,
         java_home => $java_home,
         setenv    => $setenv,
      } ->
      file { "${tomcat::basedir}/${title}":
         ensure  => absent,
         recurse => true,
         force   => true,
      }
   }
   
}
