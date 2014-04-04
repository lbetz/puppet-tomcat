define tomcat::host(
  $app_base            = undef,
  $auto_deploy         = undef,
  $unpack_wars         = undef,
  $xml_validation      = undef,
  $xml_namespace_aware = undef,
  $realms              = {},
  $contexts            = {},
  $server              = regsubst($name, '^([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^([^:]+):.*$', '\1'),
  },
  $service             = regsubst($name, '^[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:([^:]+):.*$', '\1'),
  },
  $engine              = regsubst($name, '^[^:]+:[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:[^:]+:([^:]+):.*$', '\1'),
  },
  $host                = regsubst($name, '^.*:([^:]+)$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^.*:([^:]+)$', '\1'),
  },
) {

   validate_hash($contexts)
   validate_hash($realms)
   validate_string($server)
   validate_string($service)
   validate_string($engine)
   validate_string($host)

   $basedir = "${tomcat::basedir}/${server}"
   $_name   = $host
   $_type   = 'host'

   concat::fragment { "server.xml-${name}-reference":
      target  => "${basedir}/conf/server.xml",
      content => "   <!ENTITY host-${host} SYSTEM 'host-${host}.xml'>\n",
      order   => '13',
   }

   concat::fragment { $name:
      target  => "${basedir}/conf/service-${service}.xml",
      content => "      &host-${host};\n",
      order   => '87',
   }

   concat { "${basedir}/conf/host-${host}.xml":
      owner  => 'tomcat',
      group  => 'adm',
      mode   => '0460',
   }

   concat::fragment { "${name}-header":
      target  => "${basedir}/conf/host-${host}.xml",
      content => template('tomcat/host-header.xml.erb'),
      order   => '00',
   }

   concat::fragment { "${name}-footer":
      target  => "${basedir}/conf/host-${host}.xml",
      content => "\n</Host>\n",
      order   => '99',
   }

   create_resources(tomcat::realm,
      hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:${host}:"), values($realms))))

   file { "/${basedir}/conf/${service}/${host}":
      ensure => directory,
      owner  => 'tomcat',
      group  => 'adm',
      mode   => '0570',
   }

}
