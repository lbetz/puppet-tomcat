class tomcat::params {

   $version = '6'

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
