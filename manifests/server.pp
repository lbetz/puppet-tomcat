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
#   Enable (true, default) or disable (false) the service to start at boot.
#
# [*listeners*]
#   Hash of listeners in the global server section (server.xml).
#
# [*port*]
#   Management port (default 8005) on localhost for this instance.
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
# [*managed*]
#   Enables (default) the configuration of server.xml by this module. Disable means, that the end user
#   have to manage the configuration outside and start/restart the service.
#
# [*setenv*]
#   Handles environment variables in 'bin/setenv-local.sh'.
#
# === Examples
#
# tomcat::server { 'myapp1':
#   ensure   => 'running',
#   enable   => false,
#   port     => '8005',
#   java_home => '/etc/alternatives/jre_1.7.0',
#   services => {
#      'Catalina' => {
#         'connectors' => {
#            'http-8080' => {
#               port => '8080',
#               address => '192.168.56.202',
#               protocol => 'HTTP/1.1',
#               redirect_port => '8443',
#            },
#            'ajp-8009' => {
#               port => '8009',
#               address => '192.168.56.202',
#               protocol => 'AJP/1.3',
#               redirect_port => '8443',
#            },
#         },
#         'engine' => {
#            'Catalina' => {
#               'default_host' => 'localhost',
#               'realms'       => {
#                  'org.apache.catalina.realm.LockOutRealm' => {
#                     'realms' => {
#                        'org.apache.catalina.realm.UserDatabaseRealm' => {
#                           'attrs' => {
#                              'resource_name' => 'UserDatabase',
#                           },
#                        },
#                     },
#                  },
#               },
#               'hosts' => {
#                  'localhost' => {
#                     'app_base'            => 'webapps',
#                     'unpack_wars'         => true,
#                     'auto_deploy'         => true,
#                     'xml_validation'      => false,
#                     'xml_namespace_aware' => false,
#                     'realms'              => {
#                        'org.apache.catalina.realm.LockOutRealm' => {
#                           'realms' => {
#                              'org.apache.catalina.realm.UserDatabaseRealm' => {
#                                 'attrs' => {
#                                    'resource_name' => 'UserDatabase',
#                                 },
#                              },
#                           },
#                        },
#                     },
#                  },
#               }, # hosts
#            },
#         }, # engine
#      },
#   }, # services
#   resources => {
#      'UserDatabase' => {
#         'auth'        => 'Container',
#         'type'        => 'org.apache.catalina.UserDatabase',
#         'extra_attrs' => {
#            'description' => 'User database that can be updated and saved',
#            'factory'     => 'org.apache.catalina.users.MemoryUserDatabaseFactory',
#            'pathname'    => 'conf/tomcat-users.xml',
#         },
#      },
#   }, # resources
#   listeners => {
#      'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
#      'org.apache.catalina.core.JasperListener' => {},
#      'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
#      'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
#   },
# }, # tomcat::server
#
#	
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
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

      anchor { "tomact::server::${title}::begin":
         before => Tomcat::Server::Install[$title],
         notify => Tomcat::Server::Service[$title],
      }

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

      anchor { "tomact::server::${title}::end":
         require => Tomcat::Server::Service[$title],
      }

   }
   else {

      anchor { "tomact::server::${title}::begin": } ->
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
      } ->
      anchor { "tomact::server::${title}::end": }
   }
   
}