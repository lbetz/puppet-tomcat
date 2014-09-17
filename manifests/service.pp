# == Define Resource: tomcat::service
#
# Full description of define tomcat::service here.
#
# === Parameters
#
# Using titles like 'server:service' are split off automaticly in parameters 'server' and
# 'service'. That defines the service 'service' in section server of the configuration
# file 'server.xml' for tomcat server instance 'server'.
#
# [*server*]
#    Name of tomcat server instance to add the connector,
#    automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef.
#
# [*service*]
#    Name of tomcat engine to add the service 'service',
#    automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef.
#
# [*connectors*]
#    Hash of connectors and their attributes. If sets and non equal to empty hash {}, the default is used:
#
# [*engine*]
#    Hash of the engine and their attributes.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
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
      $_engine = $tomcat::engine
   }
   if $connectors {
      validate_hash($connectors)
      $_connectors = $connectors }
   else {
      $_connectors = $tomcat::connectors
   }

   if $tomcat::standalone {
      $confdir = $params::conf[$version]['confdir'] }
   else {
      $confdir = "${tomcat::basedir}/${server}/conf"
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
