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
   $_name   = $service
   $_type   = 'service'

   concat::fragment { "server.xml-${name}-reference":
      target  => "${basedir}/conf/server.xml",
      content => "   <!ENTITY service-${service} SYSTEM 'service-${service}.xml'>\n",
      order   => '05',
   }

   concat::fragment { "server.xml-${name}-service":
      target  => "${basedir}/conf/server.xml",
      content => "   &service-${service};\n",
      order   => '60',
   }

   concat { "${basedir}/conf/service-${service}.xml":
      owner  => 'tomcat',
      group  => 'adm',
      mode   => '0460',
   }
      
   concat::fragment { "${name}-header":
      target  => "${basedir}/conf/service-${service}.xml",
      content => "<Service name='${service}'>\n\n",
      order   => '00',
   }

   concat::fragment { "${name}-footer":
      target  => "${basedir}/conf/service-${service}.xml",
      content => "\n</Service>\n",
      order   => '99',
   }
  
   create_resources(tomcat::connector,
      hash(zip(prefix(keys($connectors), "${server}:${service}:"), values($connectors))))

   create_resources(tomcat::engine,
      hash(zip(prefix(keys($engine), "${server}:${service}:"), values($engine))))

}
