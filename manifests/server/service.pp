define tomcat::server::service(
   $ensure = 'running',
   $enable = true,
) {

   service { "tomcat-${title}":
      ensure => $ensure ? {
         absent   => stopped,
         stopped  => stopped,
         default  => 'running',
      },
      enable => $enable,
   }

}
