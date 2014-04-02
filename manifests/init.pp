# == Class: tomcat
#
# Full description of class tomcat here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { tomcat:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class tomcat(
   $version = $params::version,
   $release = 'installed',
   $basedir = $params::basedir,
) inherits tomcat::params {

   validate_re($version, '^[6-7]$')
   validate_absolute_path($basedir)

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

   file { "/etc/init.d/${service}":
      ensure => file,
      mode   => '0644',
   } ->

   file { $basedir:
      ensure => directory,
   }

}
