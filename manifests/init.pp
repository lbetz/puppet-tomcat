# == Class: tomcat
#
# This class installs the tomcat software and stops the standalone server, then 'config' is
# set to 'false'. Otherwise for standalone use 'config' as hash to configure the server.
#
# === Parameters
#
# Document parameters here.
#
# [*version*]
#    of the apache tomcat server, supported versions are 6 and 7 (default)
#
# [*release*]
#    valid values are 'latest', 'installed' or exact release version, i.e. '6.0.24-64.el6_5'
#
# [*config*]
#    Hash to configure a standalone server with the distribution layout. Default is 'false',
#    that means you wanna use more than one instance.
#
# [*basedir*]
#    Base directory where to install server instance and their configurations. Directory 
#    'basedir' has to exist. Ignored for multi instance setup (config => false).
#
# === Examples
#
#  class { tomcat:
#    version => '6',
#    release => '6.0.24-64.el6_5',
#    basedir => '/var/tomcat',
#  }
#
#
# Standalone or distro like file layout
#
#  class { tomcat:
#    version => '6',
#    release => '6.0.24-64.el6_5',
#    config  => {},
#  }
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class tomcat(
   $version    = $params::version,
   $release    = 'installed',
   $basedir    = $params::basedir,
   $config     = false,
) inherits tomcat::params {

   validate_re($version, '^[6-7]$')
   validate_absolute_path($basedir)

   $catalina_home   = $params::conf[$version]['catalina_home']
   $packages        = $params::conf[$version]['packages']
   $service         = $params::conf[$version]['service']
   $catalina_script = $params::conf[$version]['catalina_script']

   package { $packages:
      ensure => $release,
   } ->

   file { $catalina_script:
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => 'puppet:///modules/tomcat/catalina.sh',
   } ->

   file { "${catalina_home}/bin/setclasspath.sh":
      ensure  => file,
      owner   => 'root',
      group   => $group,
      mode    => '0664',
      source  => 'puppet:///modules/tomcat/setclasspath.sh',
   }

   if ! $config {
      file { "/etc/init.d/${service}":
         ensure => file,
         mode   => '0644',
         require => File["${catalina_home}/bin/setclasspath.sh"],
      } ->

      file { $basedir:
         ensure => directory,
         owner  => 'root',
         group  => 'root',
         mode   => '0755',
      } ->
      
      service { $service:
         ensure => stopped,
         enable => false,
      }
   }
   else {
      # for standalone name define resource tomcat::server to 'tomcat6' or 'tomcat'
      tomcat::server { $service: }
   }

}
