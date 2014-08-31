#tomcat

####Table of Contents

1. [Overview - What is the apache module?](#overview)

##Overview

The tomcat module allows you to set up and manage a standalone or multiple instances.

##Module Description

###Compatibility

This module is currently aimed at the RHEL and Debian packaged versions of Tomcat
versions 6 and 7. 

It has only been tested on CentOS6 and Debian7 with the base OS tomcat 6 and
tomcat 7 (EPEL for RHEL) packages.

###Requirements

  - Puppet 3.x
  - puppetlabs/stdlib >= 3.2.1
  - puppetlabs/concat >= 1.0.1

##Setup

###Beginning with Tomcat

All tomcat packages will be installed and tomcat is configured as standalone server.
The OS specific file and directory structure is used, i.e. /etc/tomcat6/server.xml.
Hash config could contain the hole configuration or just a part of it. For defaults
take a look to manifests/params.pp, defaults hash.
```puppet
class { 'tomcat': }
```

To install tomcat 7 standalone with an AJP connector instead of HTTP use the following:
```puppet
class { 'tomcat':
  version => '7',
  config  => {
    services => {
      Catalina => {
        connectors => {
          ajp-8009 => {
            port     => '8009',
            protocol => 'AJP/1.3',
          },
        },
      },
    }, # services
  },
}
```

Or use this yaml file in your hiera datastore:
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

###Configure a virtual host

Setup a new virtual host instead the default host 'localhost', using a JRE 6.
```yaml
tomcat::config:
  java_home: '/etc/alternatives/jre_1.6.0'
  services: 
    Catalina
      engine:
        Catalina:
          default_host: 'www.example.com'
          hosts:
            www.example.com:
              app_base: 'webapps'
              unpack_wars: true
              auto_deploy: true
              xml_validation: false
              xml_namespace_aware: false
```
 
Configure and manage another virtual host. First part of the title is the servername, tomcat6 or tomcat7 for standalone server. The second part is the service, the third the engine there the virtual host 'www.example.com' belongs to.

tomcat::host { 'tomcat6:Catalina:Catalina:www.example.com':
  app_base            => 'webapps',
  unpack_wars         => true,
  auto_deploy         => true,
  xml_validation      => false,
  xml_namespace_aware => false,
}

###Configure multiple instances

For using tomcat as multi instance server, set the config parameter to false. That will shutdown and
disable the the standalone server.
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

##Usage

###Classes and Defined Types

####Class: `tomcat`

**Parameters within `tomcat`:**

#####`version`
The version of Apache Tomcat server, supported versions are 6 (default) and 7.

#####`release`
Valid values are 'latest', 'installed' or an exact release version, i.e. '6.0.24-64.el6_5'.

#####`config`
Hash to configure a standalone server. You have to set config to false for using more than one instance.

#####`basedir`
Base directory where to install server instances and their configurations. Directory
'basedir' has to exist. Ignored for multi instance setup (config => false).

####Defined Type: `tomcat::server`

**Parameters within `tomcat::server`:**

#####`ensure`
Valid values are present or running (present), stopped.

#####`enabled`
Enable (true, default) or disable (false) the service to start at boot.

#####`listeners`
Hash of listeners in the global server section (server.xml).

#####`port`
Management port (default 8005) on localhost for this instance.

#####`resources`
Hash of global resources in the server section (server.xml).

#####`services`
Hash of services and their attributes.

#####`java_home`
Directory where to find the java binary in subdirectory bin.

#####`managed`
Enables (default) the configuration of server.xml by this module. Disable means, that you
have to manage the configuration outside and start/restart the service.

#####`setenv`
Handles environment variables in 'bin/setenv-local.sh'.

####Defined Type: `tomcat::resource`

**Parameters within `tomcat::resource`:**

#####`server`
Name of tomcat server instance to add a resource,
automaticly taken from 'title' then using 'title' like 'server:resource' otherwise undef.

#####`resource`
Name of the resource,
automaticly taken from 'title' then using 'title' like 'server:resource' otherwise undef.

#####`auth`
authentication, default 'container'

#####`type`
Take a look at Apache Tomcat documentation.

#####`extra_attrs`
Hash of extra attributes (key => value) for this resource.

####Defined Type: `tomcat::listener`

**Parameters within `tomcat::listener`:**

#####`server`
Name of tomcat server instance to add the listener,
automaticly taken from 'title' then using 'title' like 'server:class_name' otherwise undef.

#####`class_name`
Listener with class_name 'class_name',
automaticly taken from 'title' then using 'title' like 'server:class_name' otherwise undef.

#####`ssl_engine`
Specify the ssl_engine, default 'undef' (disabled).    

####Defined Type: `tomcat::service`

**Parameters within `tomcat::service`:**

#####`server`
Name of tomcat server instance to add the service,
automaticly taken from 'title' then using 'title' like 'server:service' otherwise undef.

#####`service`
Service with name 'service',
automaticly taken from 'title' then using 'title' like 'server:service' otherwise undef.

#####`connectors`
Hash of connectors and their attributes.

#####`engine`
Hash of the engine and their attributes.

####Defined Type: `tomcat::connector`

**Parameters within `tomcat::connector`:**

#####`server`
Name of tomcat server instance to add the connector,
automaticly taken from 'title' then using 'title' like 'server:service:connector' otherwise undef.

#####`service`
Name of tomcat service to add the connector,
automaticly taken from 'title' then using 'title' like 'server:service:connector' otherwise undef.

#####`connector`
Name of the connector,
automaticly taken from 'title' then using 'title' like 'server:service:connector' otherwise undef.

#####`uri_encoding`
accepted encoding

#####`port`
Listen port, default 8080 (HTTP/1.1)

#####`address`
Address to bind, default is false that means bind to all interfaces.

#####`protocol`
Supported protocols are HTTP/1.1 (default) and AJP/1.3.

For these parameters, take a look at the Apache Tomcat documentation:
*`connection_timeout`
*`redirect_port`
*`options`
*`scheme`
*`executor`

####Defined Type: `tomcat::engine`

**Parameters within `tomcat::engine`:**

#####`server`
Name of tomcat server instance to add the connector,
automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef.

#####`service`
Name of tomcat engine to add the service 'service',
automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef.

#####`engine`
Name of the engine,
automaticly taken from 'title' then using 'title' like 'server:service:engine' otherwise undef.

#####`default_host`
Every engine has to have a default host, default 'localhost'.

#####`hosts`
Hash of hosts defined under this engine.

#####`realms`
Hash of realms defined under this engine.

####Defined Type: `tomcat::realm`

**Parameters within `tomcat::realm`:**

#####`server`
Name of tomcat server instance to add the connector,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef.

#####`service`
Name of tomcat engine to add the service 'service',
automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef.

#####`engine`
Name of the engine,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef.

#####`host`
Name of the host,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef.

#####`realm`
Name of the realm,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef.

#####`class_name`
Classname used for this realm,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host:realm:class_name' otherwise undef.

#####`attrs`
Hash of attributes defined for this realm.

#####`realms`
Hash of realms defined under this realm.

####Defined Type: `tomcat::host`

**Parameters within `tomcat::host`:**

#####`server`
Name of tomcat server instance to add the connector,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef.

#####`service`
Name of tomcat engine to add the service 'service',
automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef.

#####`engine`
Name of the engine,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef.

#####`host`
Name of the host,
automaticly taken from 'title' then using 'title' like 'server:service:engine:host' otherwise undef.

#####`realms`
Hash of realms defined for this host.

#####`contexts`
Hash of contexts defined for this host.

For these parameters, take a look at the Apache Tomcat documentation:
*`app_base`
*`auto_deploy`
*`unpack_wars`
*`xml_validation`
*`xml_namespace_aware`
