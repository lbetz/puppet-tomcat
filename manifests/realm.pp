define tomcat::realm(
  $resource_name,
  $server     = regsubst($name, '^([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^([^:]+):.*$', '\1'),
  },
  $service    = regsubst($name, '^[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:([^:]+):.*$', '\1'),
  },
  $engine     = regsubst($name, '^[^:]+:[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:[^:]+:([^:]+):.*$', '\1'),
  },
  $host       = regsubst($name, '^[^:]+:[^:]+:[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:[^:]+:[^:]+:([^:]+):.*$', '\1'),
  },
  $class_name = regsubst($name, '^.*:([^:]+)$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^.*:([^:]+)$', '\1'),
  },
) {

   validate_string($server)
   validate_string($service)
   validate_string($engine)
   validate_string($class_name)

   $basedir = "${tomcat::basedir}/${server}"

   if $host == undef {
      concat::fragment { $name:
         target  => "${basedir}/conf/service-${service}.xml",
         content => "      <Realm className='${class_name}' resourceName='${resource_name}'/>\n",
        order   => '83',
      }
   } else {
      validate_string($host)
      concat::fragment { $name:
         target  => "${basedir}/conf/host-${host}.xml",
         content => "   <Realm className='${class_name}' resourceName='${resource_name}'/>\n",
         order   => '30',
      }
   }
}
