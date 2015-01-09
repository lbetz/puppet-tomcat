# == Define Resource: tomcat::resource
#
# Full description of define tomcat::resource here.
#
# === Parameters
#
# Using titles like 'server:resource' are split off automaticly in parameters 'server'
# and 'resource'. That defines a global resource 'resource' in the configuration
# file server.xml for tomcat server instance 'server'.
#
# [*server*]
#    Name of tomcat server instance to add a resource.
#    automaticly taken from 'title' then using 'title' like 'server:resource' otherwise undef
#
# [*resource*]
#    Name of the resource,
#    automaticly taken from 'title' then using 'title' like 'server:resource' otherwise undef
#
# [*auth*]
#    authentication, default 'container'
#
# [*type*]
#    see apache tomcat documentation
#
# [*extra_attrs*]
#    Hash of extra attributes (key => value) for this resource.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::resource(
  $type,
  $server      = regsubst($name, '^([^:]+):[^:]+$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^([^:]+):[^:]+$', '\1'),
  },
  $resource    = regsubst($name, '^[^:]+:([^:]+)$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:([^:]+)$', '\1'),
  },
  $auth        = 'container',
  $extra_attrs = {},
) {

  validate_hash($extra_attrs)

  $version = $tomcat::version

  if $tomcat::standalone {
    $confdir = $params::conf[$version]['confdir'] }
  else {
    $confdir = "${tomcat::basedir}/${server}/conf"
  }

  concat::fragment { "server.xml-${name}":
    target  => "${confdir}/server.xml",
    content => template('tomcat/resource.xml.erb'),
    order   => '35',
  }

}
