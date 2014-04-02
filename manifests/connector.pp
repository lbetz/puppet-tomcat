define tomcat::connector(
   $server             = regsubst($name, '^([^:]+):[^:]+:[^:]+$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^([^:]+):[^:]+:[^:]+$', '\1'), },
   $service            = regsubst($name, '^[^:]+:([^:]+):.*$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:([^:]+):.*$', '\1'), },
   $connector          = regsubst($name, '^[^:]+:[^:]+:([^:]+)$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:[^:]+:([^:]+)$', '\1'), },
   $uri_encoding       = 'UTF-8',
   $port               = '8080',
   $address            = false,
   $protocol           = 'HTTP/1.1',
   $connection_timeout = '20000',
   $redirect_port      = '8443',
   $options            = [],
   $scheme             = false,
   $executor           = false,
) {

   $basedir = "${tomcat::basedir}/${server}"
   $_name   = $connector
   $_type   = 'connector'

   concat::fragment { "server.xml-${name}-reference":
      target  => "${basedir}/conf/server.xml",
      content => "   <!ENTITY connector-${connector} SYSTEM 'connector-${connector}.xml'>\n",
      order   => '06',
   }

   concat::fragment { $name:
      target  => "${basedir}/conf/service-${service}.xml",
      content => "   &connector-${connector};\n",
      order   => '10',
   }

   file { "${basedir}/conf/connector-${connector}.xml":
      ensure  => file,
      owner   => 'tomcat',
      group   => 'adm',
      mode    => '0460',
      content => template('tomcat/connector.xml.erb'),
   }

}
