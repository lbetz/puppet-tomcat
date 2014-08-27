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

All tomcat packages will be installed and tomcat is configured as standalone server.
The OS specific file and directory structure is used, i.e. /etc/tomcat6/server.xml.
Hash config could contain the hole configuration or just a part of it. For defaults
take a look to manifests/params.pp, defaults hash.
```puppet
class { 'tomcat': }
```

To install tomcat 7 standalone with an AJP connector instead of HTTP use the following
yaml file in your hiera datastore.
```yaml
tomcat::version: '7'
tomcat::config:
  services:
    Catalina:
      connectors:
        ajp-8009:
          port: '8009'
          protocol: 'AJP/1.3'
```

For using tomcat as multi instance server, defaults are set in params.pp class.
```puppet
class { 'tomcat':
   config  => false,
}
```

Installs base OS tomcat version 6 packages in specified version 6.0.24-72.el6_5.
All configuration files and webapps for instances of tomcat will be stored under
/var/tomcat in a subdirectory named as the tomcat::server title.
```puppet
class { 'tomcat':
   version => '6',
   release => '6.0.24-72.el6_5',
   basedir => '/var/tomcat',
   config  => false,
}
```

Setup a new instance of tomcat, using a Java Runtime Environment 1.6.0 and management port 8005.
Base directory for this instance is $basdir/myapp1, $basedir (default /var/www) set in tomcat class. 
````puppet
tomcat::server { 'myapp1':
   ensure   => 'running',
   enable   => false,
   port     => '8005',
   java_home => '/etc/alternatives/jre_1.6.0',
}
```

For detail documentation, please have a look at the inline documentaion of the source code.
