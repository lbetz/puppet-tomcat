# == Define Resource: tomcat::connector
#
# Full description of define tomcat::connector here.
#
# === Parameters
#
# Using titles like 'server:service:connector' are split off automaticly in parameters 'server',
# 'service' and 'connector'. That defines the 'connector' in section 'service' in the configuration
# file server.xml for tomcat server 'server'.
#
# [*server*]
#    Name of tomcat server instance to add the connector.
#    automaticly taken from 'title' then using 'title' like 'server:service:connector' otherwise undef
#
# [*service*]
#    Name of tomcat service to add the connector.
#    automaticly taken from 'title' then using 'title' like 'server:service:connector' otherwise undef
#
# [*connector*]
#    Name of connector.
#    automaticly taken from 'title' then using 'title' like 'server:service:connector' otherwise undef
#
# [*uri_encoding*]
#    accepted encoding
#
# [*port*]
#    listen port, default 8080 (HTTP/1.1)
#
# [*address*]
#    address to bind, default is false that means bind to all interfaces
#
# [*protocol*]
#    supported protocols are HTTP/1.1 (default) and AJP/1.3
#
# [*connection_timeout*]
#    see tomcat documentation
#
# [*redirect_port*]
#    see tomcat documentation
#
# [*options*]
#    see tomcat documentation
#
# [*scheme*]
#    see tomcat documentation
#
# [*executor*]
#    see tomcat documentation
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::connector(
  $server             = regsubst($name, '^([^:]+):[^:]+:[^:]+$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^([^:]+):[^:]+:[^:]+$', '\1'), },
  $service            = regsubst($name, '^[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:([^:]+):.*$', '\1'), },
  $connector          = regsubst($name, '^[^:]+:[^:]+:([^:]+)$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:[^:]+:([^:]+)$', '\1'), },
  $uri_encoding       = 'UTF-8',
  $port               = '8080',
  $address            = false,
  $protocol           = 'HTTP/1.1',
  $connection_timeout = '20000',
  $redirect_port      = '8443',
  $options            = [],
  $scheme             = false,
  $executor           = false,
) {

  $version         = $tomcat::version

  if $tomcat::standalone {
    $confdir = $params::conf[$version]['confdir'] }
  else {
    $confdir = "${tomcat::basedir}/${server}/conf"
  }

  concat::fragment { "server.xml-${name}":
    target  => "${confdir}/server.xml",
    content => template('tomcat/connector.xml.erb'),
    order   => "50_${service}_10",
  }

}
