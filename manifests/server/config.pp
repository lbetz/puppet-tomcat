define tomcat::server::config(
   $port,
   $services,
   $listeners,
   $resources,
) {

   $server  = $title
   $basedir = "${tomcat::basedir}/${server}"
   $owner   = $params::owner

   concat { "${basedir}/conf/server.xml":
      owner   => $owner,
      group   => 'adm',
      mode    => '0460',
   }

   concat::fragment { "server.xml-${server}-header":
      target  => "${basedir}/conf/server.xml",
      content => "<?xml version='1.0' encoding='utf-8'?>\n<!DOCTYPE server-xml [\n",
      order   => '00',
   }

   concat::fragment { "server.xml-${server}-server":
      target  => "${basedir}/conf/server.xml",
      content => "]>\n\n<Server port='${port}' shutdown='SHUTDOWN'>\n",
      order   => '10',
   }

   concat::fragment { "server.xml-${server}-globalresources-header":
      target  => "${basedir}/conf/server.xml",
      content => "\n   <GlobalNamingResources>\n",
      order   => '30',
   }

   concat::fragment { "server.xml-${server}-globalresources-footer":
      target  => "${basedir}/conf/server.xml",
      content => "   </GlobalNamingResources>\n\n",
      order   => '39',
   }

   concat::fragment { "server.xml-${server}-footer":
      target  => "${basedir}/conf/server.xml",
      content => "\n</Server>\n",
      order   => '99',
   }

   file { "${basedir}/conf/web.xml":
      ensure => file,
      owner => $owner,
      group => 'adm',
      mode  => '0460',
      source => 'puppet:///modules/tomcat/web.xml',
   }

   create_resources('tomcat::service',
      hash(zip(prefix(keys($services), "${server}:"), values($services))))

   create_resources('tomcat::resource',
      hash(zip(prefix(keys($resources), "${server}:"), values($resources))))

   create_resources('tomcat::listener',
      hash(zip(prefix(keys($listeners), "${server}:"), values($listeners))))

}
