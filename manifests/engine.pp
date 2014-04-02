define tomcat::engine(
   $default_host = 'localhost',
   $hosts        = {},
   $realms       = {},
   $server      = regsubst($name, '^([^:]+):[^:]+:[^:]+$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^([^:]+):[^:]+:[^:]+$', '\1'), },
   $service     = regsubst($name, '^[^:]+:([^:]+):.*$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:([^:]+):.*$', '\1'), },
   $engine      = regsubst($name, '^[^:]+:[^:]+:([^:]+)$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:[^:]+:([^:]+)$', '\1'), },
) {

   validate_hash($hosts)
   validate_hash($realms)

   $basedir = "${tomcat::basedir}/${server}"

   concat::fragment { "${name}-header":
      target  => "${basedir}/conf/service-${service}.xml",
      content => "\n   <Engine name='${engine}' defaultHost='${default_host}'>\n\n",
      order   => '80',
   }

   concat::fragment { "${name}-footer":
      target  => "${basedir}/conf/service-${service}.xml",
      content => "\n   </Engine>\n",
      order   => '89',
   }

   create_resources(tomcat::host,
      hash(zip(prefix(keys($hosts), "${server}:${service}:${engine}:"), values($hosts))))

   create_resources(tomcat::realm,
      hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:"), values($realms))))

}
