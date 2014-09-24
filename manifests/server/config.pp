# == private Define Resource: tomcat::server::config
#
# Full description of define tomcat::server::config here.
#
# === Parameters
#
# Document parameters here.
#
# [*user*]
#   user context for running of this instance.
#
# [*group*]
#   same for group
#
# [*port*]
#   Management port (default 8005) on localhost for this instance.
#
# [*listeners*]
#   Hash of listeners in the global server section (server.xml).
#
# [*resources*]
#   Hash of global resources in the server section (server.xml).
#
# [*services*]
#   Hash of services and their attributes.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::config(
   $user,
   $group,
   $port,
   $services,
   $listeners,
   $resources,
   $manage,
) {

   if $module_name != $caller_module_name {
      fail("tomcat::server::config is a private define resource of module tomcat, you're not able to use.")
   }

   $version       = $tomcat::version
   $server        = $title

   if $tomcat::standalone {
      $confdir       = $params::conf[$version]['confdir'] }
   else {
      $confdir       = "${tomcat::basedir}/${title}/conf"
   }

   if $manage {

      # initial copy of policy.d on debian systems for instances only
      if ! $standalone and $::osfamily == 'debian' {
         file { "${confdir}/policy.d":
            ensure  => file,
            recurse => true,
            replace => false,
            source  => "file:${params::conf[$version]['confdir']}/policy.d",
         }
      }

      concat { "${confdir}/server.xml":
         owner   => 'root',
         group   => $group,
         mode    => '0664',
      }

      concat::fragment { "server.xml-${server}-header":
         target  => "${confdir}/server.xml",
         content => "<?xml version='1.0' encoding='utf-8'?>\n",
         order   => '00',
      }

      concat::fragment { "server.xml-${server}-server":
         target  => "${confdir}/server.xml",
         content => "\n<Server port='${port}' shutdown='SHUTDOWN'>\n",
         order   => '10',
      }

      concat::fragment { "server.xml-${server}-globalresources-header":
         target  => "${confdir}/server.xml",
         content => "\n   <GlobalNamingResources>\n",
         order   => '30',
      }

      concat::fragment { "server.xml-${server}-globalresources-footer":
         target  => "${confdir}/server.xml",
         content => "   </GlobalNamingResources>\n\n",
         order   => '39',
      }

      concat::fragment { "server.xml-${server}-footer":
         target  => "${confdir}/server.xml",
         content => "\n</Server>\n",
         order   => '99',
      }

      create_resources('tomcat::listener',
         hash(zip(prefix(keys($listeners), "${server}:"), values($listeners))))

      create_resources('tomcat::resource',
         hash(zip(prefix(keys($resources), "${server}:"), values($resources))))

      create_resources('tomcat::service',
         hash(zip(prefix(keys($services), "${server}:"), values($services))))

   } # manage

}
