# == Class: tomcat
#
# This class installs the tomcat software and configure a standalone server. Switch to
# multi server by setting ensure to stopped and enable to false.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#    present or running (present), stopped
#
# [*enable*]
#    Enables (true, default) or disables (false) the service to start at boot.
#
# [*version*]
#    of the apache tomcat server, supported versions are 6 (default) and 7.
#
# [*release*]
#    valid values are 'latest', 'installed' or exact release version, i.e. '6.0.24-64.el6_5'
#
# [*listeners*]
#   Hash of listeners in the global server section (server.xml).
#
# [*port*]
#   Management port (default 8005) on localhost.
#
# [*resources*]
#   Hash of global resources in the server section (server.xml).
#
# [*services*]
#   Hash of services and their attributes.
#
# [*manage*]
#    Enables (default) the configuration by this module. Disable means, that you have
#    to manage the configuration in server.xml outside and notify the service.
#
# [*setenv*]
#   Handles environment variables in sysconfig file.
#
# [*basedir*]
#    Base directory where to install server instances and their configurations. Directory
#    'basedir' has to exist. Ignored for standalone setup (ensure => stopped, enable => false).
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
# Standalone in distro like file layout
#
#  class { tomcat:
#    ensure  => stopped,
#    enable  => false,
#    version => '6',
#    release => '6.0.24-64.el6_5',
#  }
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class tomcat(
   $ensure    = running,
   $enable    = true,
   $release   = installed,
   $version   = $params::version,
   $port      = '8005',
   $listeners = $params::listeners[$version],
   $resources = $params::resources,
   $services  = $params::services,
   $java_home = $params::java_home,
   $manage    = true,
   $setenv    = [],
   $basedir   = $params::basedir,
) inherits tomcat::params {

   validate_re($ensure, '^(running|stopped)$',
      "${ensure} is not supported for ensure. Valid values are 'running' and 'stopped'.")
   validate_bool($enable)
   validate_re($version, '^[6-7]$', 'Supported versions are 6 and 7')
   validate_hash($listeners)
   validate_hash($resources)
   validate_hash($services)
   validate_absolute_path($java_home)
   validate_absolute_path($basedir)
   validate_bool($manage)

   $user          = $params::conf[$version]['user']
   $group         = $params::conf[$version]['group']
   $sysconfig     = $params::conf[$version]['sysconfig']
   $service       = $params::conf[$version]['service']
   $catalina_home = $params::conf[$version]['catalina_home']
   $catalina_base = $params::conf[$version]['catalina_base']
   $catalina_pid  = $params::conf[$version]['catalina_pid']
   $tempdir       = $params::conf[$version]['tempdir']
   $logdir        = $params::conf[$version]['logdir']

   if $ensure == 'stopped' and ! $enable {
      $standalone = false }
   else {
      $standalone = true
   }

   class { 'install': }
   -> anchor { 'tomcat::begin':
      notify => Service[$service],
   }
   -> file { $sysconfig:
      ensure => $standalone ? {
         true    => file,
         default => absent,
      },
      owner   => 'root',
      group   => $group,
      mode    => '0664',
      content => template('tomcat/sysconfig.erb'),
      notify  => Service[$service],
   }
   -> file { $catalina_pid:
      ensure => $standalone ? {
         true    => file,
         default => absent,
      },
      owner  => $user,
      group  => $group,
      mode   => '0644',
   }
   -> tomcat::server::config { $service:
      user      => $user,
      group     => $group,
      port      => $port,
      services  => $services,
      listeners => $listeners,
      resources => $resources,
      manage    => $standalone ? {
         false   => false,
         default => $manage,
      },
   }
   ~> service { $service:
      ensure => $ensure,
      enable => $enable,
      hasstatus => false,
      pattern => "-Dcatalina.base=${params::conf[$version]['catalina_base']}",
   }
   -> anchor { 'tomcat::end': }

}
