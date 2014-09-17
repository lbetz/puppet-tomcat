# == Define Resource: tomcat::engine
#
# Full description of define tomcat::engine here.
#
# === Parameters
#
# Using titles like 'server:service:engine' are split off automaticly in parameters 'server',
# 'service' and 'engine'. That defines the engine 'engine' in section 'service' of the configuration
# file 'server.xml' for tomcat server instance 'server'. 
#
# [*server*]
#    Name of tomcat server instance to add the connector.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef
#
# [*service*]
#    Name of tomcat engine to add the service 'service'.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef
#
# [*engine*]
#    Name of the engine.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef
#
# [*default_host*]
#    every engine has to have a default host, default 'localhost'
#
# [*hosts*]
#    Hash of hosts defined under this engine.
#
# [*realms*]
#    Hash of realms defined under this engine.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::engine(
   $default_host = 'localhost',
   $hosts        = undef,
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

   validate_hash($realms)

   $version = $tomcat::version

   if $hosts {
      validate_hash($hosts)
      if ! has_key($hosts, $default_host) {
         warning("The defined default host '${default_host}' doesn't exist, adding a default entry.")
         $_hosts = merge($hosts, { "${default_host}" => $tomcat::hosts['localhost'] }) }
      else {
        $_hosts = $hosts }
      }
   else {
      $_hosts = { "${default_host}" => $tomcat::hosts['localhost'] }
   }
   
   if $tomcat::standalone {
      $confdir = $params::conf[$version]['confdir'] }
   else {
      $confdir = "${tomcat::basedir}/${server}/conf"
   }

   concat::fragment { "server.xml-${name}-header":
      target  => "${confdir}/server.xml",
      content => "\n      <Engine name='${engine}' defaultHost='${default_host}'>\n\n",
      order   => "50_${service}_20",
   }

   concat::fragment { "server.xml-${name}-footer":
      target  => "${confdir}/server.xml",
      content => "\n      </Engine>\n",
      order   => "50_${service}_89",
   }

   # todo: maybe change the ownership
   file { "${confdir}/${engine}":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '2775',
   }

   create_resources(tomcat::host,
      hash(zip(prefix(keys($_hosts), "${server}:${service}:${engine}:"), values($_hosts))))

   create_resources(tomcat::realm,
      hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:"), values($realms))))

}
