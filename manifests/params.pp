class tomcat::params {

   $version = '6'

   case $::osfamily {

      'redhat': {
         $basedir   = '/var/tomcat'
         $java_home = '/usr/lib/jvm/jre'

         $conf      = { '6' => {
                         'user'            => 'tomcat',
                         'group'           => 'tomcat',
                         'sysconfig'       => '/etc/sysconfig/tomcat6',
                         'catalina_home'   => '/usr/share/tomcat6',
                         'catalina_base'   => '/usr/share/tomcat6',
                         'catalina_pid'    => '/var/run/tomcat6.pid',
                         'package'         => 'tomcat6',
                         'service'         => 'tomcat6',
                         'bindir'          => '/usr/share/tomcat6/bin',
                         'confdir'         => '/etc/tomcat6',
                         'libdir'          => '/usr/share/java/tomcat6',
                         'logdir'          => '/var/log/tomcat6',
                         'tempdir'         => '/var/cache/tomcat6/temp',
                         'webappdir'       => '/var/lib/tomcat6/webapps',
                         'workdir'         => '/var/cache/tomcat6/work',
                         'initd'           => '/etc/init.d/tomcat6',
                      },
                      '7' => {
                         'user'            => 'tomcat',
                         'group'           => 'tomcat',
                         'sysconfig'       => '/etc/sysconfig/tomcat',
                         'catalina_home'   => '/usr/share/tomcat',
                         'catalina_base'   => '/usr/share/tomcat',
                         'catalina_pid'    => '/var/run/tomcat.pid',
                         'package'         => 'tomcat',
                         'service'         => 'tomcat',
                         'bindir'          => '/usr/share/tomcat/bin',
                         'confdir'         => '/etc/tomcat',
                         'libdir'          => '/usr/share/java/tomcat',
                         'logdir'          => '/var/log/tomcat',
                         'tempdir'         => '/var/cache/tomcat/temp',
                         'webappdir'       => '/var/lib/tomcat/webapps',
                         'workdir'         => '/var/cache/tomcat/work',
                         'initd'           => '/etc/init.d/tomcat',
                      },
         }

      }

      'debian': {
         $basedir   = '/var/tomcat'
         $java_home = '/usr/lib/jvm/default-java/jre'
         $conf      = { '6' => {
                         'owner'           => 'tomcat6',
                         'group'           => 'tomcat6',
                         'sysconfig'       => '/etc/default/tomcat6',
                         'catalina_home'   => '/usr/share/tomcat6',
                         'catalina_base'   => '/var/lib/tomcat6',
                         'catalina_pid'    => '/var/run/tomcat6.pid',
                         'package'         => 'tomcat6',
                         'service'         => 'tomcat6',
                         'bindir'          => '/usr/share/tomcat6/bin',
                         'confdir'         => '/etc/tomcat6',
                         'libdir'          => '/usr/share/tomcat6/lib',
                         'logdir'          => '/var/log/tomcat6',
                         'tempdir'         => '/var/cache/tomcat6',
                         'webappdir'       => '/var/lib/tomcat6/webapps',
                         'workdir'         => '/var/cache/tomcat6/work',
                         'initd'           => '/etc/init.d/tomcat6',
                      },
                      '7' => {
                         'owner'           => 'tomcat7',
                         'group'           => 'tomcat7',
                         'sysconfig'       => '/etc/default/tomcat7',
                         'catalina_home'   => '/usr/share/tomcat7',
                         'catalina_base'   => '/var/lib/tomcat7',
                         'catalina_pid'    => '/var/run/tomcat7.pid',
                         'package'         => 'tomcat7',
                         'service'         => 'tomcat7',
                         'bindir'          => '/usr/share/tomcat7/bin',
                         'confdir'         => '/etc/tomcat7',
                         'libdir'          => '/usr/share/tomcat7/lib',
                         'logdir'          => '/var/log/tomcat7',
                         'tempdir'         => '/var/cache/tomcat7',
                         'webappdir'       => '/var/lib/tomcat7/webapps',
                         'workdir'         => '/var/cache/tomcat7/work',
                         'initd'           => '/etc/init.d/tomcat7',
                      },
         }

      }

      default: {
         fail('Your plattform is not support, yet.')
      }

   }

   $connectors = {
      'http-8080' => {
         port => '8080',
         protocol => 'HTTP/1.1',
         redirect_port => '8443',
      },
   }
   $listeners = {
      '6' => {
         'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
         'org.apache.catalina.core.JasperListener' => {},
         'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
         'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
         'org.apache.catalina.mbeans.ServerLifecycleListener' => {},
      },
      '7' => {
         'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
         'org.apache.catalina.core.JasperListener' => {},
         'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
         'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
         'org.apache.catalina.core.ThreadLocalLeakPreventionListener' => {},
      },
   }
   $hosts = {
      'localhost' => {
         'app_base'            => 'webapps',
         'unpack_wars'         => true,
         'auto_deploy'         => true,
         'xml_validation'      => false,
         'xml_namespace_aware' => false,
      },
   }
   $engine = {
      'Catalina' => {
         'realms' => {
           'org.apache.catalina.realm.UserDatabaseRealm' => {
              'attrs' => {
                 'resource_name' => 'UserDatabase',
              },
           },
        },
      },
   }
   $services = {
      'Catalina' => {},
   }
   $resources = {
      'UserDatabase' => {
         'auth'        => 'Container',
         'type'        => 'org.apache.catalina.UserDatabase',
         'extra_attrs' => {
            'description' => 'User database that can be updated and saved',
            'factory'     => 'org.apache.catalina.users.MemoryUserDatabaseFactory',
            'pathname'    => 'conf/tomcat-users.xml',
         },
      },
   }


}
