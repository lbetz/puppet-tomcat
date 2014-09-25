#tomcat

##Overview

The tomcat module allows you to set up and manage a standalone or multiple instances.

##Module Description

###Compatibility

This module is currently aimed at the RHEL and Debian packaged versions of Tomcat
versions 6 and 7. 

It has only been tested on CentOS6, Debian6 and Debian7 with the base OS tomcat 6 and
tomcat 7 packages.

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
  version  => '7',
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
}
```

Or use this yaml file in your hiera datastore:
```yaml
tomcat::version: '7'
tomcat::services:
  Catalina:
    connectors:
      ajp-8009:
        port: '8009'
        protocol: 'AJP/1.3'
```

###Configure a virtual host

Setup a new virtual host instead the default host 'localhost', using a JRE 6.
```yaml
tomcat::java_home: '/etc/alternatives/jre_1.6.0'
tomcat::services:
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

For using tomcat as multi instance server, set ensure to 'stopped' and enable to 'false'. That will shutdown and
disable the the standalone server.
```puppet
class { 'tomcat':
   ensure => stopped,
   enable => false,
}
```

Installs base OS tomcat version 6 packages in specified version 6.0.24-72.el6_5.
All configuration files and webapps for instances of tomcat will be stored under
/var/tomcat in a subdirectory named as the tomcat::server title.
```puppet
class { 'tomcat':
   ensure  => stopped,
   enable  => false,
   version => '6',
   release => '6.0.24-72.el6_5',
   basedir => '/var/tomcat',
}
```

Setup a new instance of tomcat, using a Java Runtime Environment 1.6.0 and management port 8005.
Base directory for this instance is $basdir/myapp1, $basedir (default /var/tomcat) set in tomcat class. 
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

#####`ensure`
present or running (present), stopped

#####`enable`
Enables (true, default) or disables (false) the service to start at boot.

#####`version`
The version of Apache Tomcat server, supported versions are 6 (default) and 7.

#####`release`
Valid values are 'latest', 'installed' or an exact release version, i.e. '6.0.24-64.el6_5'.

#####`port`
Management port (default 8005) on localhost.

#####`listeners`
Hash of listeners in the global server section (server.xml).

#####`resources`
Hash of global resources in the server section (server.xml).

#####`services`
Hash of services and their attributes.

#####`manage`
Enables (default) the configuration by this module. Disable means, that you have
to manage the configuration in server.xml outside and notify the service.

#####`setenv`
Handles environment variables in sysconfig file.

#####`basedir`
Base directory where to install server instances and their configurations. Directory
'basedir' has to exist. Ignored for multi instance setup (config => false).

####Defined Type: `tomcat::server`

Notice: parameters you set in declaration of class `tomcat` acts as defaults for `tomcat::server`.

**Parameters within `tomcat::server`:**

#####`ensure`
Valid values are present or running (present), stopped.

#####`enabled`
Enables (true, default) or disables (false) the service to start at boot.

#####`user`
user context for running of this instance.

#####`group`
same for group
```puppet
class { 'tomcat':
   ensure  => stopped,
   enable  => false,
   version => 6,
}

tomcat::server { 'myapp1': }

group { 'myapp2':
   ensure => present,
}

user { 'myapp2':
   ensure => present,
   gid    => 'myapp2',
   shell  => '/sbin/nologin',
   home   => '/var/tomcat/myapp1',
} ->

tomcat::server { 'myapp2':
   user     => 'myapp2',
   group    => 'myapp2',
   port     => '8006',
   services => {
      'Catalina' => {
         connectors => {
            'ajp-8009' => {
               port => '8009',
               protocol => 'AJP/1.3',
               redirect_port => '8443',
            },
         },
      },
   },
}
```

#####`port`
Management port (default 8005) on localhost for this instance.

#####`listeners`
Hash of listeners in the global server section (server.xml). Default, for Tomcat 6 
```puppet
'listeners' => {
  'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
  'org.apache.catalina.core.JasperListener' => {},
  'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
  'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
  'org.apache.catalina.mbeans.ServerLifecycleListener' => {},
},
```
rather for Tomcat 7
```puppet
'listeners' => {
  'org.apache.catalina.core.AprLifecycleListener' => { 'ssl_engine' => 'On', },
  'org.apache.catalina.core.JasperListener' => {},
  'org.apache.catalina.core.JreMemoryLeakPreventionListener' => {},
  'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener' => {},
  'org.apache.catalina.core.ThreadLocalLeakPreventionListener' => {},
},
```

#####`resources`
Hash of global resources in the server section (server.xml), default sets to:
```puppet
resources => {
  'UserDatabase' => {
    'auth'        => 'Container',
    'type'        => 'org.apache.catalina.UserDatabase',
    'extra_attrs' => {
    'description' => 'User database that can be updated and saved',
    'factory'     => 'org.apache.catalina.users.MemoryUserDatabaseFactory',
    'pathname'    => 'conf/tomcat-users.xml',
  },
},
```

#####`services`
Hash of services and their attributes.

#####`java_home`
Directory where to find the java binary in subdirectory bin.

#####`manage`
Enables (default) the configuration of server.xml by this module. Disable means, that
you have to manage the configuration outside and start/restart the service.
```puppet
class { 'tomcat':
   ensure  => stopped,
   enable  => false,
   version => '6',
}

tomcat::server { 'myapp1':
   manage => false,
}

file { '/var/tomcat/myapp1/conf/server.xml':
   ensure => file,
   owner  => 'root',
   group  => 'root',
   mode   => '0644',
   source => 'puppet:///modules/tomcat/example-server.xml',
   notify => Tomcat::Server::Service['myapp1'],
}
```
Notice notifying Tomcat::Server does not work, you have to do this against Tomcat::Server::Service. 

#####`setenv`
Handles environment variables in 'bin/setenv.sh'.
```puppet
setenv => [ 'JAVA_XMX="256m"', 'JAVA_XX_MAXPERMSIZE="256m' ]
```
Variables to use:
* `DSUN_JAVA2D_OPENGL` true|false
* `DJAVA_AWT_HEADLESS` true|false
* `JAVA_XMX` 
* `JAVA_XX_MAXPERMSIZE`

Use `ADD_JAVA_OPTS` for all other environment variables.
```puppet
setenv => [ 'ADD_JAVA_OPTS="-Xminf0.1 -Xmaxf0.3"' ]

####Defined Type: `tomcat::resource`

```puppet
tomcat::resource { 'myapp1:UserDatabase':
  auth        => 'Container',
  type        => 'org.apache.catalina.UserDatabase',
  extra_attrs => {
    description => 'User database that can be updated and saved',
    factory     => 'org.apache.catalina.users.MemoryUserDatabaseFactory',
    pathname    => 'conf/tomcat-users.xml',
  },
}
```

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

```puppet
tomcat::listener { 'myapp1:org.apache.catalina.core.AprLifecycleListener':
  ssl_engine => 'On',
}
```

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

```puppet
tomcat::service { 'myapp1:Catalina':
  connetcors => {},
  engine     => {},
}
```

**Parameters within `tomcat::service`:**

#####`server`
Name of tomcat server instance to add the service,
automaticly taken from 'title' then using 'title' like 'server:service' otherwise undef.

#####`service`
Service with name 'service',
automaticly taken from 'title' then using 'title' like 'server:service' otherwise undef.

#####`connectors`
Hash of connectors and their attributes. If sets and non equal to empty hash {}, the default is used:
```puppet
connectors => {
  'http-8080' => {
    port          => '8080',
    protocol      => 'HTTP/1.1',
    redirect_port => '8443',
}
```

#####`engine`
Hash of the engine and their attributes.

####Defined Type: `tomcat::connector`

```puppet
tomcat::connector { 'myapp1:Catalina:ajp-8009':
  port          => '8009',
  protocol      => 'AJP/1.3',
  redirect_port => '8443',
}
```

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
* `connection_timeout`
* `redirect_port`
* `options`
* `scheme`
* `executor`

####Defined Type: `tomcat::engine`

```puppet
tomcat::engine { 'myapp1:Catalina:Catalina':
  default_host => 'localhost'
  hosts => {},
  realms => {
    'org.apache.catalina.realm.UserDatabaseRealm' => {
      'attrs' => {
        'resource_name' => 'UserDatabase',
      },
    },
  },
}
```

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

```puppet
tomcat::realm { 'myapp1:Catalina:Catalina:www.example:':
}
```

```puppet
tomcat::realm { 'myapp1:Catalina:Catalina:*:':
}
```

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

```puppet
tomcat::host { 'myapp1:Catalina:Catalina:www.example.com':
  realms              => {},
  app_base            => 'webapps',
  unpack_wars         => true,
  auto_deploy         => true,
  xml_validation      => false,
  xml_namespace_aware => false,
}
```
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

For these parameters, take a look at the Apache Tomcat documentation:
* `app_base`
* `auto_deploy`
* `unpack_wars`
* `xml_validation`
* `xml_namespace_aware`
