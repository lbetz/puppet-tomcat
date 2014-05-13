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
            require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}/50_${host}"],
         }
         concat::fragment { "server.xml-${name}-footer":
            target  => "${basedir}/conf/server.xml",
            content => "            </Realm>\n",
            order   => "50_${service}/50_${host}/21",
            require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}/50_${host}"],
         }
         create_resources(tomcat::realm,
            hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:${host}:${class_name}:"), values($realms))))
      } else {
         concat::fragment { "server.xml-${name}":
            target  => "${basedir}/conf/server.xml",
            content => "            ${_content} />\n",
            order   => "50_${service}/50_${host}/23",
            require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}/50_${host}"],
         }
      }
   } else {
      if $realms != {} {
         concat::fragment { "server.xml-${name}-header":
            target  => "${basedir}/conf/server.xml",
            content => "   ${_content}>\n",
            order   => "50_${service}/40",
            require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}"],
         }
         concat::fragment { "server.xml-${name}-footer":
            target  => "${basedir}/conf/server.xml",
            content => "   </Realm>\n",
            order   => "50_${service}/41",
            require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}"],
         }
         create_resources(tomcat::realm,
            hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:*:${class_name}:"), values($realms))))
      } else {
         concat::fragment { "server.xml-${name}":
            target  => "${basedir}/conf/server.xml",
            content => "   ${_content} />\n",
            order   => '43',
            require => File["${::vardir}/concat/${_subdir}/fragments/50_${service}"],
         }
      }
   }

}
