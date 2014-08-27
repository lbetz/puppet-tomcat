class { 'tomcat':
   config => {
      port      => '8005',
      java_home => '/usr/lib/jvm/jre',
      services => {
         'Catalina' => {
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
