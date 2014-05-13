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

   $basedir = "${tomcat::basedir}/${server}"

   concat::fragment { $name:
      target  => "${basedir}/conf/server.xml",
      content => inline_template("   <Listener className='<%= @class_name %>'<% if @ssl_engine %> SSLEngine='<%= @ssl_engine %>'<% end %>/>\n"),
      order   => '20',
   }

}
