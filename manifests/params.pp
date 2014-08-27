class tomcat::params {

   $version = '6'

   $defaults = {
      'connectors' => {
         'http-8080' => {
            port => '8080',
            protocol => 'HTTP/1.1',
            redirect_port => '8443',
         },
      },
      'listeners' => {
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
            'org.apache.catalina.core.ThreadLocalLeakPreventionListene' => {},
         },
      },
      'hosts' => {
         'localhost' => {
            'app_base'            => 'webapps',
            'unpack_wars'         => true,
            'auto_deploy'         => true,
            'xml_validation'      => false,
            'xml_namespace_aware' => false,
         },
      },
      'engine' => {
         'Catalina' => {
            'realms' => {
               'org.apache.catalina.realm.UserDatabaseRealm' => {
                  'attrs' => {
                     'resource_name' => 'UserDatabase',
                  },
               },
            },
         },
      },
      services => {
         'Catalina' => {},
      },
   }

   case $::osfamily {

      'redhat': {
         $basedir = '/var/tomcat'
         $owner   = 'tomcat'
         $group   = 'tomcat'
         $conf    = { '6' => {
                         'catalina_home'   => '/usr/share/tomcat6',
                         'catalina_script' => '/usr/sbin/tomcat6',
                         'packages'        => 'tomcat6',
                         'service'         => 'tomcat6',
         		 'bindir'          => '/usr/share/tomcat6/bin',
                         'confdir'         => '/etc/tomcat6',
                         'libdir'          => '/usr/share/java/tomcat6',
                         'logdir'          => '/var/log/tomcat6',
                         'tempdir'         => '/var/cache/tomcat6/temp',
                         'webappdir'       => '/var/lib/tomcat6/webapps',
                         'workdir'         => '/var/cache/tomcat6/work',
                      },
                      '7' => {
                         'catalina_home'   => '/usr/share/tomcat',
                         'catalina_script' => '/usr/sbin/tomcat',
                         'packages'        => 'tomcat',
                         'service'         => 'tomcat',
         		 'bindir'          => '/usr/share/tomcat/bin',
                         'confdir'         => '/etc/tomcat',
                         'libdir'          => '/usr/share/java/tomcat',
                         'logdir'          => '/var/log/tomcat',
                         'tempdir'         => '/var/cache/tomcat/temp',
                         'webappdir'       => '/var/lib/tomcat/webapps',
                         'workdir'         => '/var/cache/tomcat/work',
                      },
         }

      }

      default: {
         fail('Yout platform is not supported, yet.')
      }

   }

}
