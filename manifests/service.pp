define tomcat::service(
   $connectors = undef,
   $engine     = undef,
   $server     = regsubst($name, '^([^:]+):[^:]+$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^([^:]+):[^:]+$', '\1'), },
   $service = regsubst($name, '^[^:]+:([^:]+)$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:([^:]+)$', '\1'), },
) {

   validate_string($server)
   validate_string($service)

   $version = $tomcat::version
   if $engine {
      validate_hash($engine)
      $_engine = $engine }
   else {
      $_engine = $params::defaults['engine']
   }
   if $connectors {
      validate_hash($connectors)
      $_connectors = $connectors }
   else {
      $_connectors = $params::defaults['connectors']
   }

   # standalone
   if $tomcat::config {
      $basedir = $params::conf[$version]['catalina_home']
      $confdir = $params::conf[$version]['confdir']
   }
   # multi instance
   else {
      $basedir = "${tomcat::basedir}/${server}"
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
      hash(zip(prefix(keys($_connectors), "${server}:${service}:"), values($_connectors))))

   create_resources(tomcat::engine,
      hash(zip(prefix(keys($_engine), "${server}:${service}:"), values($_engine))))

}
