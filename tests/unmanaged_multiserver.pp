class { 'tomcat':
   ensure  => stopped,
   enable  => false,
   version => '6',
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
   user   => 'myapp1',
   group  => 'myapp1',
   manage => false,
}

file { '/var/tomcat/myapp1/conf/server.xml':
   ensure => file,
   owner  => 'root',
   group  => 'root',
   mode   => '0664',
   source => 'puppet:///modules/tomcat/example1-tomcat6-server.xml',
   notify => Tomcat::Server::Service['myapp1'],
}

tomcat::server { 'myapp2':
   manage => false,
}

file { '/var/tomcat/myapp2/conf/server.xml':
   ensure => file,
   owner  => 'root',
   group  => 'root',
   mode   => '0664',
   source => 'puppet:///modules/tomcat/example2-tomcat6-server.xml',
   notify => Tomcat::Server::Service['myapp2'],
}
