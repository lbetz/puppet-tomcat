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
#    of the apache tomcat server, supported versions are 6 (default) and 7.
#
# [*release*]
#    valid values are 'latest', 'installed' or exact release version, i.e. '6.0.24-64.el6_5'
#
# [*config*]
#    Hash to configure a standalone server with the distribution layout.
#
# [*basedir*]
#    Base directory where to install server instances and their configurations. Directory 
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
   $config     = {},
) inherits tomcat::params {

   validate_re($version, '^[6-7]$')
   validate_absolute_path($basedir)

   $packages        = $params::conf[$version]['packages']
   $catalina_home   = $params::conf[$version]['catalina_home']
   $service         = $params::conf[$version]['service']
   $catalina_script = $params::conf[$version]['catalina_script']
   $logdir          = $params::conf[$version]['logdir']
   $tempdir         = $params::conf[$version]['tempdir']
   $workdir         = $params::conf[$version]['workdir']
   $webappdir       = $params::conf[$version]['webappdir']
   $bindir          = $params::conf[$version]['bindir']
   $confdir         = $params::conf[$version]['confdir']
   $libdir          = $params::conf[$version]['libdir']
   $group           = $params::conf[$version]['group']

   package { $packages:
      ensure => $release,
   }

   file { $catalina_script:
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => 'puppet:///modules/tomcat/catalina.sh',
      require => Package[$packages],
   }

   file { "${catalina_home}/bin/setclasspath.sh":
      ensure  => file,
      owner   => 'root',
      group   => $group,
      mode    => '0664',
      source  => 'puppet:///modules/tomcat/setclasspath.sh',
      require => Package[$packages],
   }

   file { "${catalina_home}/conf":
      ensure => link,
      target => $confdir,
      require => Package[$packages],
   }

   file { "${catalina_home}/logs":
      ensure => link,
      target => $logdir,
      require => Package[$packages],
   }

   file { "${catalina_home}/temp":
      ensure => link,
      target => $tempdir,
      require => Package[$packages],
   }

   file { "${catalina_home}/work":
      ensure => link,
      target => $workdir,
      require => Package[$packages],
   }

   file { "${catalina_home}/webapps":
      ensure => link,
      target => $webappdir,
      require => Package[$packages],
   }

   # for standalone name define resource tomcat::server to 'tomcat6' or 'tomcat'
   if $config {
      tomcat::server { $service:
         ensure    => running,
         enable    => true,
         port      => $config['port'],
         java_home => $config['java_home'],
         services  => $config['services'],
         listeners => $config['listeners'],
         resources => $config['resources'],
         setenv    => [],
         managed   => true,
         require => File[$catalina_script],
      }
   }
   else {
      service { $service:
         ensure => stopped,
         enable => false,
         require => Package[$packages],
      } ->

      file { "/etc/init.d/${service}":
         ensure => file,
         mode   => '0644',
      } ->

      file { $basedir:
         ensure => directory,
         owner  => 'root',
         group  => 'root',
         mode   => '0755',
      }
   }

}
