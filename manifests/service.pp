define tomcat::service(
   $connectors,
   $engine     = {},
   $server     = regsubst($name, '^([^:]+):[^:]+$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^([^:]+):[^:]+$', '\1'), },
   $service = regsubst($name, '^[^:]+:([^:]+)$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:([^:]+)$', '\1'), },
) {

   validate_hash($connectors)
   validate_hash($engine)
   validate_string($server)
   validate_string($service)

   $basedir = "${tomcat::basedir}/${server}"
   #$_name   = $service
   #$_type   = 'service'
   $_subdir = regsubst("${basedir}/conf/server.xml", '\/', '_', 'G')

   file { "${::concat_basedir}/${_subdir}/fragments/50_${service}":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }

   concat::fragment { "server.xml-${name}-header":
      target  => "${basedir}/conf/server.xml",
      content => "\n   <Service name='${service}'>\n\n",
      order   => "50_${service}/00",
      require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}"],
   }

   concat::fragment { "server.xml-${name}-footer":
      target  => "${basedir}/conf/server.xml",
      content => "\n   </Service>\n",
      order   => "50_${service}/99",
      require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}"],
   }

   create_resources(tomcat::connector,
      hash(zip(prefix(keys($connectors), "${server}:${service}:"), values($connectors))))

   create_resources(tomcat::engine,
      hash(zip(prefix(keys($engine), "${server}:${service}:"), values($engine))))

}
