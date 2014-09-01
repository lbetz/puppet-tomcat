class { 'tomcat':
   version => '6',
   config  => {
      managed => false,
   }
}

file { '/etc/tomcat6/server.xml':
   ensure => file,
   owner  => 'root',
   group  => 'root',
   mode   => '0644',
   source => 'puppet:///modules/tomcat/example-server.xml',
   notify => Tomcat::Server::Service['tomcat6'],
}
