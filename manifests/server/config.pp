define tomcat::server::config(
   $ensure = 'present',
   $port,
   $services,
   $listeners,
   $resources,
   $java_home,
) {

   $server          = $title
   $basedir         = "${tomcat::basedir}/${server}"
   $version         = $tomcat::version
   $owner           = $params::owner
   $catalina_home   = $params::config[$version]['catalina_home']
   $catalina_script = $params::config[$version]['catalina_script']

   File {
      owner => $owner,
      group => 'adm',
      mode  => '0460',
   }

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
      order   => '20',
   }

   concat::fragment { "server.xml-${server}-globalresources-header":
      target  => "${basedir}/conf/server.xml",
      content => "\n   <GlobalNamingResources>\n",
      order   => '40',
   }

   concat::fragment { "server.xml-${server}-globalresources-footer":
      target  => "${basedir}/conf/server.xml",
      content => "   </GlobalNamingResources>\n\n",
      order   => '49',
   }

   concat::fragment { "server.xml-${server}-footer":
      target  => "${basedir}/conf/server.xml",
      content => "\n</Server>",
      order   => '99',
   }

   file { "/etc/init.d/tomcat-${title}":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      content => template('tomcat/tomcat.init.erb'),
   }

   file { "${basedir}/conf/web.xml":
      ensure => file,
      source => 'puppet:///modules/tomcat/web.xml',
   }

   create_resources('tomcat::service',
      hash(zip(prefix(keys($services), "${server}:"), values($services))))

   create_resources('tomcat::resource',
      hash(zip(prefix(keys($resources), "${server}:"), values($resources))))

   create_resources('tomcat::listener',
      hash(zip(prefix(keys($listeners), "${server}:"), values($listeners))))

}
