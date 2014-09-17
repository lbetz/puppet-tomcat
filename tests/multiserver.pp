class { 'tomcat':
   ensure  => stopped,
   enable  => false,
   version => 6,
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
   user     => 'myapp1',
   group    => 'myapp1',
   services => {
      'Catalina' => {
         connectors => {
            'ajp-8009' => {
               port => '8009',
               protocol => 'AJP/1.3',
               redirect_port => '8443',
            },
         },
      },
   },
   port     => '8006',
}

tomcat::server { 'myapp2': }
