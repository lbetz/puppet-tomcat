# == Define Resource: tomcat::listener
#
# Full description of define tomcat::listener here.
#
# === Parameters
#
# Using titles like 'server:class_name' are split off automaticly in parameters 'server'
# and 'class_name'. That defines the listener 'class_name' in the configuration
# file server.xml for tomcat server 'server'. 
#
# [*server*]
#    Name of tomcat server instance to add the connector.
#    automaticly taken from 'title' then using 'title' like 'server:class_name' otherwise undef
#
# [*class_name*]
#    listener with class_name 'class_name',
#    automaticly taken from 'title' then using 'title' like 'server:class_name' otherwise undef
#
# [*ssl_engine*]
#    specify the ssl_engine, default 'undef' (disabled)    
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::listener(
  $server     = regsubst($name, '^([^:]+):.*$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^([^:]+):.*$', '\1'),
  },
  $class_name = regsubst($name, '^.*:([^:]+)$', '\1') ? {
    $name   => undef,
    default => regsubst($name, '^.*:([^:]+)$', '\1'),
  },
  $ssl_engine = undef,
) {

   validate_string($server)
   validate_string($class_name)

   $version = $tomcat::version

   # standalone
   if $tomcat::config {
      $basedir = $params::conf[$version]['catalina_home']
      $confdir = $params::conf[$version]['confdir']
   }
   # multi instance
   else {
      $basedir = "${tomcat::basedir}/${title}"
      $confdir  = "${basedir}/conf"
   }

   concat::fragment { $name:
      target  => "${confdir}/server.xml",
      content => inline_template("   <Listener className='<%= @class_name %>'<% if @ssl_engine %> SSLEngine='<%= @ssl_engine %>'<% end %>/>\n"),
      order   => '20',
   }

}
