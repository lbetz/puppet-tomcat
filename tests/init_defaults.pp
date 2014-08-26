class { 'tomcat':
   config => {
      port      => '8005',
      java_home => '/usr/lib/jvm/jre',
      services => {
         'Catalina' => {
            'engine' => {
               'Catalina' => {
                  'realms' => {
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
            }, # engine
         },
      }, # services
      resources => {
         'UserDatabase' => {
            'auth'        => 'Container',
            'type'        => 'org.apache.catalina.UserDatabase',
            'extra_attrs' => {
               'description' => 'User database that can be updated and saved',
               'factory'     => 'org.apache.catalina.users.MemoryUserDatabaseFactory',
               'pathname'    => 'conf/tomcat-users.xml',
            },
         },
      }, # resources
   }
}
