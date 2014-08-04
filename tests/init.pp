class { 'tomcat':
   config => {
      port      => '8005',
      java_home => '/etc/alternatives/jre_1.7.0',
      services => {
         'Catalina' => {
            'connectors' => {
               'http-8080' => {
                  port => '8080',
                  protocol => 'HTTP/1.1',
                  redirect_port => '8443',
                },
               'ajp-8009' => {
                  port => '8009',
                  protocol => 'AJP/1.3',
                  redirect_port => '8443',
               },
            },
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
                  'default_host' => 'localhost',
                  'hosts' => {
                     'localhost' => {
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
      listeners => {
         'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
         'org.apache.catalina.core.JasperListener' => {},
         'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
         'org.apache.catalina.mbeans.ServerLifecycleListener' => {},
         'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
      },
   }
}
