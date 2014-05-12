# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
class { 'tomcat':
   version => '7',
} ->

tomcat::server { 'myapp1':
   ensure   => 'running',
   enable   => false,
   port     => '8005',
   java_home => '/etc/alternatives/jre_1.7.0',
   services => { 
      'Catalina' => { 
         'connectors' => {
            "http-8080" => {
               port => '8080', address => '192.168.56.202', protocol => 'HTTP/1.1', redirect_port => '8443',
            },
            "ajp-8009" => {
               port => '8009', address => '192.168.56.202', protocol => 'AJP/1.3', redirect_port => '8443',
            }
         },
         'engine' => { 
            'Catalina' => {
               'default_host' => 'localhost',
               'realms'       => { 
                  'org.apache.catalina.realm.LockOutRealm' => {
                     'realms' => {
                         'org.apache.catalina.realm.UserDatabaseRealm' => {
                            'attrs' => {
                               'resource_name' => 'UserDatabase', 
                            },
                         },
                     },
                  },
               },        
               'hosts'        => {
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
                     },        
                  },
               },
            },
         },
      },
   },
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
   },
   listeners => {
      'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
      'org.apache.catalina.core.JasperListener' => {},
      'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
#      'org.apache.catalina.mbeans.ServerLifecycleListener' => {},
      'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
   },

} ->

tomcat::server { 'myapp2':
   ensure   => running,
   enable   => false,
   port     => '8006',
   java_home => '/etc/alternatives/jre_1.6.0',
   services => { 
      'Catalina' => { 
         'connectors' => {
            "http-8080" => {
               port => '8080', address => '127.0.0.1', protocol => 'HTTP/1.1', redirect_port => '8443',
            },
            "ajp-8009" => {
               port => '8009', address => '127.0.0.1', protocol => 'AJP/1.3', redirect_port => '8443',
            },
         },
         'engine' => { 
            'Catalina' => {
               'default_host' => 'localhost2',
               'realms'       => { 
                  'org.apache.catalina.realm.UserDatabaseRealm' => {
                     'attrs' => {
                        'resource_name' => 'UserDatabase', 
                     },
                  },
               },        
               'hosts'        => {
                  'localhost2' => {
                     'app_base'            => 'webapps',
                     'unpack_wars'         => true,
                     'auto_deploy'         => true,
                     'xml_validation'      => false,
                     'xml_namespace_aware' => false,
                  },
               },
            },
         },
      },
   },
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
   },
   listeners => {
      'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
      'org.apache.catalina.core.JasperListener' => {},
      'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
#      'org.apache.catalina.mbeans.ServerLifecycleListener' => {},
      'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
   },
}
