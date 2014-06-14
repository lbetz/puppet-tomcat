# == Define Resource: tomcat::realm
#
# Full description of define tomcat::realm here.
#
# === Parameters
#
# Using titles like 'server:service:engine:host:realm:class_name' are split off automaticly in parameters 'server',
# 'service', 'engine', 'host' and 'realm'. That defines a realm in 'host' of the 'engine' in section
# 'service' of the configuration file 'server.xml' for tomcat server instance 'server'.
#
# [*server*]
#    Name of tomcat server instance to add the connector.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef
#
# [*service*]
#    Name of tomcat engine to add the service 'service'.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef
#
# [*engine*]
#    Name of the engine.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef
#
# [*realm*]
#    Name of the engine.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef
#
# [*class_name*]
#    Classname used for this realm.
#    automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef
#
# [*attrs*]
#    Hash of attributes defined for this realm.
#
# [*realms*]
#    Hash of realms defined under this realm.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::realm(
  $attrs         = {},
  $realms        = {},
  $server        = regsubst($name, '^([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^([^:]+):.*$', '\1'),
  },
  $service       = regsubst($name, '^[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:([^:]+):.*$', '\1'),
  },
  $engine        = regsubst($name, '^[^:]+:[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:[^:]+:([^:]+):.*$', '\1'),
  },
  $host          = regsubst($name, '^[^:]+:[^:]+:[^:]+:([^:]+):.*$', '\1') ? {
    $name   => undef,
    '*'     => undef,
    default => regsubst($name, '^[^:]+:[^:]+:[^:]+:([^:]+):.*$', '\1'),
  },
  $realm         = regsubst($name, '^[^:]+:[^:]+:[^:]+:[^:]:([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^[^:]+:[^:]+:[^:]+:[^:]:([^:]+):.*$', '\1'),
  },
  $class_name    = regsubst($name, '^.*:([^:]+)$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^.*:([^:]+)$', '\1'),
  },
) {

   validate_hash($realms)
   validate_hash($attrs)
   validate_string($server)
   validate_string($service)
   validate_string($engine)
   validate_string($realm)
   validate_string($class_name)

   $basedir = "${tomcat::basedir}/${server}"
   $_subdir = regsubst("${basedir}/conf/server.xml", '\/', '_', 'G')

   $_content = inline_template("<Realm className='<%= @class_name %>'<% @attrs.keys.sort.each do |key| -%> <%= key %>='<%= @attrs[key] %>'<% end -%>")

   if $host {
      validate_string($host)
      if $realms != {} {
         concat::fragment { "server.xml-${name}-header":
            target  => "${basedir}/conf/server.xml",
            content => "            ${_content}>\n",
            order   => "50_${service}/50_${host}/20",
            require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}/50_${host}"],
         }
         concat::fragment { "server.xml-${name}-footer":
            target  => "${basedir}/conf/server.xml",
            content => "            </Realm>\n",
            order   => "50_${service}/50_${host}/21",
            require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}/50_${host}"],
         }
         create_resources(tomcat::realm,
            hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:${host}:${class_name}:"), values($realms))))
      } else {
         concat::fragment { "server.xml-${name}":
            target  => "${basedir}/conf/server.xml",
            content => "            ${_content} />\n",
            order   => "50_${service}/50_${host}/23",
            require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}/50_${host}"],
         }
      }
   } else {
      if $realms != {} {
         concat::fragment { "server.xml-${name}-header":
            target  => "${basedir}/conf/server.xml",
            content => "   ${_content}>\n",
            order   => "50_${service}/40",
            require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}"],
         }
         concat::fragment { "server.xml-${name}-footer":
            target  => "${basedir}/conf/server.xml",
            content => "   </Realm>\n",
            order   => "50_${service}/41",
            require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}"],
         }
         create_resources(tomcat::realm,
            hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:*:${class_name}:"), values($realms))))
      } else {
         concat::fragment { "server.xml-${name}":
            target  => "${basedir}/conf/server.xml",
            content => "   ${_content} />\n",
            order   => '43',
            require => File["${::concat_basedir}/${_subdir}/fragments/50_${service}"],
         }
      }
   }

}
