# == private Class: tomcat::install
#
# Full description of define tomcat::install here.
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class tomcat::install {

   if $module_name != $caller_module_name {
      fail("tomcat::install is a private define resource of module tomcat, you're not able to use.")
   }

   $version = $tomcat::version
   $release = $tomcat::release
   $basedir = $tomcat::basedir
   $package = $params::conf[$version]['package']
   $group   = $params::conf[$version]['group']
   $confdir = $params::conf[$version]['confdir']
   $bindir  = $params::conf[$version]['bindir']

   package { $package:
      ensure => $release,
   } 

   -> file { $confdir:
      ensure => directory,
      owner  => 'root',
      group  => $group,
      mode   => '0775',
   }

   if ! $tomcat::standalone {
      file { $basedir:
         ensure => directory,
         owner  => 'root',
         group  => 'root',
         mode   => '0775',
      }
   }

}
