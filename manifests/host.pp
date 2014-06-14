# == Define Resource: tomcat::host
#
# Full description of define tomcat::listener here.
#
# === Parameters
#
# Using titles like 'server:service:engine:host' are split off automaticly in parameters 'server',
# 'service', 'engine' and 'host'. That defines a host under 'engine' in section 'service' of the configuration
# file 'server.xml' for tomcat server instance 'server'. 
#
# [*server*]
#    Name of tomcat server instance to add the connector.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef
#
# [*service*]
#    Name of tomcat engine to add the service 'service'.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef
#
# [*engine*]
#    Name of the engine.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef
#
# [*host*]
#    Name of the host.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef
#
# [*app_base*]
#
# [*auto_deploy*]
#
# [*unpack_wars*]
#
# [*xml_validation*]
#
# [*xml_namespace_aware*]
#
# [*realms*]
#    Hash of realms defined for this host.
#
# [*contexts*]
#    Hash of contexts defined for this host.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
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
   #$_name   = $host
   #$_type   = 'host'
   $_subdir = regsubst("${basedir}/conf/server.xml", '\/', '_', 'G')

   file { "${::concat_basedir}/${_subdir}/fragments/50_${service}/50_${host}":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
   }

   concat::fragment { "server.xml-${name}-header":
      target  => "${basedir}/conf/server.xml",
      content => template('tomcat/host-header.xml.erb'),
      order   => "50_${service}/50_${host}/00",
      require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}/50_${host}"],
   }

   concat::fragment { "server.xml-${name}-footer":
      target  => "${basedir}/conf/server.xml",
      content => "\n         </Host>\n",
      order   => "50_${service}/50_${host}/99",
      require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}/50_${host}"],
   }

   create_resources(tomcat::realm,
      hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:${host}:"), values($realms))))

}
