class { 'tomcat':
   version => '6',
   config  => false,
} ->

tomcat::server { 'myapp1':
   managed => false,
}

file { '/var/tomcat/myapp1/conf/server.xml':
   ensure => file,
   owner  => 'root',
   group  => 'root',
   mode   => '0644',
   source => 'puppet:///modules/tomcat/example-server.xml',
   notify => Tomcat::Server::Service['myapp1'],
}
