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

   $version = $tomcat::version

   # standalone
   if $tomcat::config {
      $basedir = $params::conf[$version]['catalina_home']
      $confdir = $params::conf[$version]['confdir']
   }
   # multi instance
   else {
      $basedir = "${tomcat::basedir}/${title}"
      $confdir  = "${basedir}/conf"
   }

   concat::fragment { "server.xml-${name}-header":
      target  => "${confdir}/server.xml",
      content => "\n   <Service name='${service}'>\n\n",
      order   => "50_${service}_00",
   }

   concat::fragment { "server.xml-${name}-footer":
      target  => "${confdir}/server.xml",
      content => "\n   </Service>\n",
      order   => "50_${service}_99",
   }

   create_resources(tomcat::connector,
      hash(zip(prefix(keys($connectors), "${server}:${service}:"), values($connectors))))

   create_resources(tomcat::engine,
      hash(zip(prefix(keys($engine), "${server}:${service}:"), values($engine))))

}
