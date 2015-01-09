# == private Define Resource: tomcat::server::install
#
# Full description of define tomcat::server::install here.
#
# === Parameters
#
# Document parameters here.
#
# [*user*]
#   user context for running of this instance.
#
# [*group*]
#   same for group
#
# === Authors
#
# Author Lennart Betz <lennart.betz@netways.de>
#
define tomcat::server::install(
  $user,
  $group,
) {

  if $module_name != $caller_module_name {
    fail("tomcat::server::install is a private define resource of module tomcat, you're not able to use.")
  }

  $basedir       = "${tomcat::basedir}/${title}"
  $version       = $tomcat::version
  $service       = $params::conf[$version]['service']
  $initd         = $params::conf[$version]['initd']
  $systemd       = $params::systemd

  file { [$basedir, "${basedir}/bin", "${basedir}/lib", "${basedir}/webapps", "${basedir}/work"]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "${basedir}/conf":
    ensure => directory,
    owner  => 'root',
    group  => $group,
    mode   => '0775',
  }

  file { ["${basedir}/logs", "${basedir}/temp"]:
    ensure => directory,
    owner  => $user,
    group  => 'root',
    mode   => '0755',
  }

  if $systemd and $::osfamily != 'debian' {
    file { "/etc/systemd/system/${service}-${title}.service":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('tomcat/systemd.service.erb'),
      notify  => Exec['tomcat::systemd::daemon-reload'],
    }
  }
  else {
    if $systemd {
      $notify = Exec['tomcat::systemd::daemon-reload']
    }

    file { "${initd}-${title}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      replace => false,
      source  => "file:${initd}"
    } ~>

    exec { "change provider in ${initd}-${title}":
      path        => '/bin:/usr/bin',
      command     => "sed -i 's/^\\(#\\s*Provides:\\s*\\|NAME=\\)${service}$/\\1${service}-${title}/g' ${initd}-${title}",
      #unless     => "grep '^#\s*Provides:\s*${service}-${title}'  ${initd}-${title}",
      refreshonly => true,
      notify      => $notify,
    }

  }

}
