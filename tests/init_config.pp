class { 'tomcat':
  services => {
    'Catalina2' => {
      'connectors' => {
        'ajp-8009' => {
          port          => '8009',
          protocol      => 'AJP/1.3',
          redirect_port => '8443',
        },
      },
      'engine'     => {
        'Catalina2' => {
          'default_host' => 'localhost',
          'hosts'        => {
            'localhost2' => {
              'app_base'            => 'webapps',
              'unpack_wars'         => true,
              'auto_deploy'         => true,
              'xml_validation'      => false,
              'xml_namespace_aware' => false,
              'realms'              => {
                'org.apache.catalina.realm.LockOutRealm'  => {
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
  setenv   => ['JAVA_XMX="128m"', 'JAVA_XX_MAXPERMSIZE="128m"', 'LANG="de_DE"'],
}
