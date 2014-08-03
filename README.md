puppet-tomcat
==============

# Overview #

Setup and manage Apache Tomcat for standalone and multiple instances. For more documentation
please have a look at the inline documentaion of the source code.

## Compatibility ##

This module is currently aimed at the RHEL packaged versions of Tomcat
versions 6 and 7. 

It has only been tested on CentOS6 with the base OS tomcat6 and
EPEL testing tomcat (7) packages.

## Requirements ##

  - Puppet 3.x
  - puppetlabs/stdlib >= 3.2.1
  - puppetlabs/concat >= 1.0.1

## Usage ##

To install the base OS tomcat packages, defaults are set in params.pp class.
```puppet
class { 'tomcat': }
```

Installs base OS tomcat version 6 packages in specified version 6.0.24-72.el6_5.
All configuration files and webapps for instances of tomcat will be stored under
/var/tomcat in a subdirectory named as the tomcat::server title.
```puppet
class { 'tomcat':
   version => '6',
   release => '6.0.24-72.el6_5',
   basedir => '/var/tomcat',
}
```

All tomcat packages will be installed and tomcat is configured as standalone server.
The OS specific file and directory structure is used, i.e. /etc/tomcat6/server.xml.
Hash config has to contain the hole configuration of the standalone server. No default
configuration is served by this version.
```puppet
class { 'tomcat':
   config  => {},
}
```

Setup a new instance of tomcat, using a Java Runtime Environment 1.6.0 and management port 8005.
Base directory for this instance is $basdir/myapp1, $basedir (default /var/www) set in tomcat class. 
You have to set listeners and services hashes to have a configured an runable server instance. Take
a look in file manifests/server.pp for examples.
````puppet
tomcat::server { 'myapp1':
   ensure   => 'running',
   enable   => false,
   port     => '8005',
   java_home => '/etc/alternatives/jre_1.6.0',
   listeners => {},
   port      => '8005',
   resources => {},
   services  => {},
}
```

For detail documentation, please have a look at the inline documentaion of the source code.
