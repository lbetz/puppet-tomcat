define tomcat::resource(
   $server      = regsubst($name, '^([^:]+):[^:]+$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^([^:]+):[^:]+$', '\1'),
   },
   $resource    = regsubst($name, '^[^:]+:([^:]+)$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:([^:]+)$', '\1'),
   },
   $auth        = 'container',
   $type, 
   $extra_attrs = {},
) {

   validate_hash($extra_attrs)

   $basedir = "${tomcat::basedir}/${server}"

   concat::fragment { "server.xml-${name}":
      target  => "${basedir}/conf/server.xml",
      content => template('tomcat/resource.xml.erb'),
      order   => '35',
   }

}
