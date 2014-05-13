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
   $_subdir = regsubst("${basedir}/conf/server.xml", '\/', '_', 'G')

   concat::fragment { "server.xml-${name}":
      target  => "${basedir}/conf/server.xml",
      content => template('tomcat/connector.xml.erb'),
      order   => "50_${service}/10",
      require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}"],
   }

}
