class { 'tomcat':
  ensure => stopped,
  enable => false,
}

tomcat::server { 'myapp2':
  ensure => absent
}

tomcat::server { 'myapp1':
  ensure => absent
}

user { 'myapp1':
  ensure  => absent,
  require => Tomcat::Server['myapp1'],
}
