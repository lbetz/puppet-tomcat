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
   version => '6',
   config  => false,
} ->

tomcat::server { 'myapp1':
   ensure   => 'running',
   enable   => false,
   port     => '8005',
   services => { 
      'Catalina' => { 
         'connectors' => {
            "http-8080" => {
               port => '8080', protocol => 'HTTP/1.1', redirect_port => '8443',
            },
            "ajp-8009" => {
               port => '8009', protocol => 'AJP/1.3', redirect_port => '8443',
            }
         },
      },
   },
} ->

tomcat::server { 'myapp2':
   ensure   => running,
   enable   => false,
   port     => '8006',
   services => { 
      'Catalina' => { 
         'connectors' => {
            "http-8080" => {
               port => '8081', address => '127.0.0.1', protocol => 'HTTP/1.1', redirect_port => '8443',
            },
            "ajp-8009" => {
               port => '8010', address => '127.0.0.1', protocol => 'AJP/1.3', redirect_port => '8443',
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
                  'localhost1' => {
                     'app_base'            => 'webapps',
                     'unpack_wars'         => true,
                     'auto_deploy'         => true,
                     'xml_validation'      => false,
                     'xml_namespace_aware' => false,
                  },
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
}
