# == Class: tomcat
#
# This class installs the tomcat software and stops the standalone server.
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
# [*basedir*]
#    Base directory where to install server instance and their configurations.
#
# === Examples
#
#  class { tomcat:
#    version => '6',
#    release => '6.0.24-64.el6_5',
#    basedir => '/var/tomcat',
#  }
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
class tomcat(
   $version = $params::version,
   $release = 'installed',
   $basedir = $params::basedir,
) inherits tomcat::params {

   validate_re($version, '^[6-7]$')
   validate_absolute_path($basedir)

   $catalina_home   = $params::config[$version]['catalina_home']
   $packages        = $params::config[$version]['packages']
   $service         = $params::config[$version]['service']
   $catalina_script = $params::config[$version]['catalina_script']

   package { $packages:
      ensure => $release,
   } ->

   service { $service:
      ensure => stopped,
      enable => false,
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
   } ->

   file { "/etc/init.d/${service}":
      ensure => file,
      mode   => '0644',
   } ->

   file { $basedir:
      ensure => directory,
   }

}
