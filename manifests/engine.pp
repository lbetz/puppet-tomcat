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
   $_subdir = regsubst("${basedir}/conf/server.xml", '\/', '_', 'G')

   concat::fragment { "server.xml-${name}-header":
      target  => "${basedir}/conf/server.xml",
      content => "\n      <Engine name='${engine}' defaultHost='${default_host}'>\n\n",
      order   => "50_${service}/20",
      require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}"],
   }

   concat::fragment { "server.xml-${name}-footer":
      target  => "${basedir}/conf/server.xml",
      content => "\n      </Engine>\n",
      order   => "50_${service}/89",
      require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}"],
   }

   create_resources(tomcat::host,
      hash(zip(prefix(keys($hosts), "${server}:${service}:${engine}:"), values($hosts))))

   create_resources(tomcat::realm,
      hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:"), values($realms))))

}
