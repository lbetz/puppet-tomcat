define tomcat::realm(
  $resource_name = undef,
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
   validate_string($server)
   validate_string($service)
   validate_string($engine)
   validate_string($realm)
   validate_string($class_name)

   $basedir = "${tomcat::basedir}/${server}"

   if $host {
      validate_string($host)
      if $realms != {} {
         concat::fragment { "${name}-header":
            target  => "${basedir}/conf/host-${host}.xml",
            content => inline_template("   <Realm className='<%= @class_name %>'<% if @resource_name %> resourceName='<%= @resource_name %>'<% end %>>\n"),
            order   => '30',
         }
         concat::fragment { "${name}-footer":
            target  => "${basedir}/conf/host-${host}.xml",
            content => "   </Realm>\n",
            order   => '36',
         }
         create_resources(tomcat::realm,
            hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:${host}:${class_name}:"), values($realms))))
      } else {
         concat::fragment { $name:
            target  => "${basedir}/conf/host-${host}.xml",
            content => inline_template("   <Realm className='<%= @class_name %>'<% if @resource_name %> resourceName='<%= @resource_name %>'<% end %>/>\n"),
            order   => '33',
         }
      }
   } else {
      if $realms != {} {
         concat::fragment { "${name}-header":
            target  => "${basedir}/conf/service-${service}.xml",
            content => inline_template("      <Realm className='<%= @class_name %>'<% if @resource_name %> resourceName='<%= @resource_name %>'<% end %>>\n"),
            order   => '82',
         }
         concat::fragment { "${name}-footer":
            target  => "${basedir}/conf/service-${service}.xml",
            content => "      </Realm>\n",
            order   => '86',
         }
         create_resources(tomcat::realm,
            hash(zip(prefix(keys($realms), "${server}:${service}:${engine}:*:${class_name}:"), values($realms))))
      } else {
         concat::fragment { $name:
            target  => "${basedir}/conf/service-${service}.xml",
            content => inline_template("      <Realm className='<%= @class_name %>'<% if @resource_name %> resourceName='<%= @resource_name %>'<% end %>/>\n"),
           order   => '83',
         }
      }
   }


}
