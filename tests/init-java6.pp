class { 'tomcat':
  java_home => '/etc/alternatives/jre_1.6.0',
}

file { '/etc/tomcat6/tomcat-users.xml':
  ensure => file,
  owner  => 'root',
  group  => 'tomcat',
  mode   => '0664',
  source => 'puppet:///modules/tomcat/tomcat-users.xml',
  notify => Class['tomcat'],
}
