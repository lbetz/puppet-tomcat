class { 'tomcat':
  version => '6',
  manage  => false,
}

file { '/etc/tomcat6/server.xml':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/tomcat/example1-tomcat6-server.xml',
  notify => Class['tomcat'],
}
