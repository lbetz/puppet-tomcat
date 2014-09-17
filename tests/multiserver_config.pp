class { 'tomcat':
   services => {
      'Catalina2' => {
         'connectors' => {
            'ajp-8009' => {
               port => '8009',
               protocol => 'AJP/1.3',
               redirect_port => '8443',
            },
         },
         'engine' => {
            'Catalina2' => {
               'default_host' => 'localhost',
               'hosts' => {
                  'localhost2' => {
                     'app_base'            => 'webapps',
                     'unpack_wars'         => true,
                     'auto_deploy'         => true,
                     'xml_validation'      => false,
                     'xml_namespace_aware' => false,
                     'realms'              => {
                        'org.apache.catalina.realm.LockOutRealm' => {
                           'realms' => {
                              'org.apache.catalina.realm.UserDatabaseRealm' => {
                                 'attrs' => {
                                    'resource_name' => 'UserDatabase',
                                 },
                              },
                           },
                        },
                        'org.apache.catalina.realm.CombinedRealm' => {
                           'realms' => {
                              'org.apache.catalina.realm.UserDatabaseRealm' => {
                                 'attrs' => {
                                    'resource_name' => 'UserDatabase',
                                 },
                              },
                           },
                        },
                     },
                  },
               }, # hosts
            },
         }, # engine
      },
   },
   ensure  => stopped,
   enable  => false,
   version => 6,
}

group { 'myapp1':
   ensure => present,
}

user { 'myapp1':
   ensure => present,
   gid    => 'myapp1',
   shell  => '/sbin/nologin',
   home   => '/var/tomcat/myapp1',
} ->

tomcat::server { 'myapp1':
   user     => 'myapp1',
   group    => 'myapp1',
   services => {
      'Catalina' => {
         connectors => {
            'ajp-8010' => {
               port => '8010',
               protocol => 'AJP/1.3',
               redirect_port => '8443',
            },
         },
      },
   },
   port     => '8006',
}

tomcat::server { 'myapp2': }
