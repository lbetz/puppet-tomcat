class tomcat::params {

   $version = '7'

   case $::osfamily {

      'redhat': {
         $basedir = '/var/tomcat'
         $owner   = 'tomcat'
         $group   = 'tomcat'
         $config  = { '6' => {
                         'catalina_home'   => '/usr/share/tomcat6',
                         'catalina_script' => '/usr/sbin/tomcat6',
                         'packages'        => 'tomcat6',
                         'service'         => 'tomcat6',
                         },
                      '7' => {
                         'catalina_home'   => '/usr/share/tomcat',
                         'catalina_script' => '/usr/sbin/tomcat',
                         'packages'        => 'tomcat',
                         'service'         => 'tomcat',
                      },
         }
      }

      default: {
         fail('Yout platform is not supported, yet.')
      }

   }

}
