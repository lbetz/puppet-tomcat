define tomcat::resource(
   $server      = regsubst($name, '^([^:]+):[^:]+$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^([^:]+):[^:]+$', '\1'),
   },
   $resource    = regsubst($name, '^[^:]+:([^:]+)$', '\1') ? {
      $name   => undef,
      default => regsubst($name, '^[^:]+:([^:]+)$', '\1'),
   },
   $auth        = '',
   $description = '',
   $factory     = '',
   $type        = '',
   $pathname    = '',
) {

   $basedir = "${tomcat::basedir}/${server}"

   concat::fragment { $name:
      target  => "${basedir}/conf/server.xml",
      content => template('tomcat/resource.xml.erb'),
      order   => '45',
   }

}
