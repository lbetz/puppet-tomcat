class { 'tomcat':
   config => {
      port      => '8005',
      java_home => '/usr/lib/jvm/jre',
   }
}
