# Description


The wlp cookbook installs and configures WebSphere Application Server Liberty Profile.
It provides recipes, resources, and libraries for creating, managing, and configuring Liberty profile server instances.


# Requirements

## Platform:

* Debian
* Ubuntu
* Centos
* Redhat

## Cookbooks:

* java

# Attributes

* `node[:wlp][:user]` - User name under which the server will be installed and running. Defaults to `wlp`.
* `node[:wlp][:group]` - Group name under which the server will be installed and running. Defaults to `wlp-admin`.
* `node[:wlp][:base_dir]` - Base installation directory. Defaults to `/opt/was/liberty`.
* `node[:wlp][:user_dir]` - Set user configuration directory (wlp.user.dir). Set to 'nil' to use default location. Defaults to `nil`.
* `node[:wlp][:install_method]` - Installation method. Set it to 'archive' or 'zip'. Defaults to `archive`.
* `node[:wlp][:archive][:base_url]` - Base URL location for downloading the runtime, extended, and extras Liberty profile archives. 
By default the archives are downloaded from WASdev repository. Defaults to `http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.0/`.
* `node[:wlp][:archive][:runtime][:url]` - URL location of the runtime archive. Defaults to `#{node[:wlp][:archive][:base_url]}/wlp-developers-runtime-8.5.5.0.jar`.
* `node[:wlp][:archive][:runtime][:checksum]` - Checksum value for the runtime archive. Defaults to `4032747299111a580a9ef476d539fb0f67bf6c98894e01db4555d94d35bb5175`.
* `node[:wlp][:archive][:extended][:url]` - URL location of the extended archive. Defaults to `#{node[:wlp][:archive][:base_url]}/wlp-developers-extended-8.5.5.0.jar`.
* `node[:wlp][:archive][:extended][:checksum]` - Checksum value for the extended archive. Defaults to `b3df906bd7ddeafa58121c96577ac08054208f16cb874a8684b6b132267e23a0`.
* `node[:wlp][:archive][:extended][:install]` - Controls whether the extended archive should be downloaded and installed. Defaults to `true`.
* `node[:wlp][:archive][:extras][:url]` - URL location of the extras archive. Defaults to `#{node[:wlp][:archive][:base_url]}/wlp-developers-extras-8.5.5.0.jar`.
* `node[:wlp][:archive][:extras][:checksum]` - Checksum value for the extras archive. Defaults to `7ff244a92260f032ad67733070df7f581a1a97628e01aebde808148b981396d3`.
* `node[:wlp][:archive][:extras][:install]` - Controls whether the extras archive should be downloaded and installed. Defaults to `false`.
* `node[:wlp][:archive][:extras][:base_dir]` - Base installation directory of the extras archive. Defaults to `#{node[:wlp][:base_dir]}/extras`.
* `node[:wlp][:archive][:accept_license]` - Accept license terms when doing archive-based installation. 
Must be set to `true` otherwise installation will fail. Defaults to `false`.
* `node[:wlp][:zip][:url]` - URL location to a zip file containing Liberty profile installation files. Must be set 
only when `node[:wlp][:install_method]` is set to `zip`. Defaults to `nil`.
* `node[:wlp][:servers][:defaultserver]` -  Defaults to `{ ... }`.
* `node[:wlp][:servers][:airport]` -  Defaults to `{ ... }`.

# Recipes

* [wlp::archive_install](#wlparchive_install) - Installs WebSphere Application Server Liberty Profile from jar archive files.
* [wlp::default](#wlpdefault) - Installs WebSphere Application Server Liberty Profile.
* wlp::serverconfig
* [wlp::zip_install](#wlpzip_install) - Installs WebSphere Application Server Liberty Profile from a zip file.

## wlp::archive_install

Installs WebSphere Application Server Liberty Profile from jar archive files. 
This recipe is called by the `default` recipe and should not be used directly.

## wlp::default

Installs WebSphere Application Server Liberty Profile. Liberty profile can be 
installed using jar file archives or from a zip file based on the `node[:wlp][:install_method]` setting.
By default, Liberty profile is installed using the jar archives downloaded from the WASdev site.

## wlp::zip_install

Installs WebSphere Application Server Liberty Profile from a zip file. 
This recipe is called by the `default` recipe and should not be used directly.

# Resources

* [wlp_jvm_options](#wlp_jvm_options) - Adds and removes JVM options in installation-wide or instance-specific jvm.options file.
* [wlp_server](#wlp_server) - Provides operations for creating, starting, stopping, and destroying Liberty profile server instances.
* [wlp_server_env](#wlp_server_env) - Sets and unsets environment properties in installation-wide or instance-specific server.env file.

## wlp_jvm_options

Adds and removes JVM options in installation-wide or instance-specific jvm.options file.

### Actions

- add: Adds JVM options to jvm.options file. Default action.
- remove: Removes JVM options from jvm.options file.

### Attribute Parameters

- server_name: If specified, the jvm.options file in the specified server instance is updated. Otherwise, the installation-wide jvm.options file is updated. Defaults to <code>nil</code>.
- options: The JVM options to add or remove.

### Examples
```ruby
wlp_jvm_options "add to instance-specific jvm.options" do
  server_name "myInstance"
  options [ "-Djava.net.ipv4=true" ]
  action :add
end

wlp_jvm_options "remove from instance-specific jvm.options" do
  server_name "myInstance"
  options [ "-Djava.net.ipv4=true" ]
  action :remove
end

wlp_jvm_options "add to installation-wide jvm.options" do
  options [ "-Xmx1024m" ]
  action :add
end

wlp_jvm_options "remove from installation-wide jvm.options" do
  options [ "-Xmx1024m" ]
  action :remove
end
```

## wlp_server

Provides operations for creating, starting, stopping, and destroying Liberty profile server instances.

### Actions

- start: Creates and starts the server instance (as an OS service). Default action.
- create: Creates server instance.
- destroy: Destroys server instance.
- stop: Stops the server instance (via an OS service).

### Attribute Parameters

- server_name: Name of the server instance.
- template:  Defaults to <code>nil</code>.
- jvmOptions: Instance-specific JVM options. Defaults to <code>[]</code>.
- serverEnv: Instance-specific server environment properties. Defaults to <code>{}</code>.
- clean: Clean all cached information when starting the server instance. Defaults to <code>false</code>.

### Examples
```ruby
wlp_server "myInstance" do 
  jvmOptions [ "-Djava.net.ipv4=true" ]
  serverEnv "JAVA_HOME" => "/usr/lib/j2sdk1.7-ibm/"
  action :create
end

wlp_server "myInstance" do 
  clean true
  action :start
end

wlp_server "myInstance" do
  action :stop
end

wlp_server "myInstance" do
  action :destroy
end
```

## wlp_server_env

Sets and unsets environment properties in installation-wide or instance-specific server.env file.

### Actions

- set: Sets environment properties in server.env file. Default action.
- unset: Unsets environment properties in server.env file.

### Attribute Parameters

- server_name: If specified, the server.env file in the specified server instance is updated. Otherwise, the installation-wide server.env file is updated. Defaults to <code>nil</code>.
- properties: The properties to set or unset. Must be specified as a hash when setting and as an array when unsetting. Defaults to <code>nil</code>.

### Examples
```ruby
wlp_server_env "set in instance-specific server.env" do
  server_name "myInstance"
  properties "JAVA_HOME" => "/usr/lib/j2sdk1.7-ibm/"
  action :set
end

wlp_server_env "unset in instance-specific server.env" do
  server_name "myInstance"
  properties [ "JAVA_HOME" ]
  action :unset
end

wlp_server_env "set in installation-wide server.env" do
  properties "WLP_USER_DIR" => "/var/wlp"
  action :set
end

wlp_server_env "unset in installation-wide server.env" do
  properties [ "WLP_USER_DIR" ]
  action :unset
end
```

# Development

To work on the Liberty cookbook first ensure you have [Bundler][] installed.

```bash
$ gem install bundler
```

Next, use [Bundler][] to install Liberty cookbook dependencies:

```bash
$ bundle install
```

Finally, use [Rake][] to execute various tasks. For example:

```bash
$ rake all
```

[Bundler]: http://bundler.io/
[Rake]: http://rake.rubyforge.org/



# Testing

To check syntax of the cookbook files execute:

```bash
$ rake syntax
```

To run [Foodcritic][] (lint-like tool) on the cookbook execute:

```bash
$ rake foodcritic
```

To run [ChefSpec][] tests execute:

```bash
$ rake rspec
```

The tests and cookbooks used by [ChefSpec][] are located in the **spec/** directory. The [ChefSpec][] tests are quick.

To run [test-kitchen][] tests execute:

```bash
$ rake kitchen
```

The tests and cookbooks used by [test-kitchen][] are located in the **test/** directory. The [test-kitchen][] tests are slow as virtual machines are created and configured to run the tests. See [How to speed up 'test kitchen' tests](https://github.com/WASdev/ci.chef.wlp/wiki/How-to-speed-up-%27test-kitchen%27-tests) for ways to make it run faster.


[Foodcritic]: http://acrmp.github.io/foodcritic/
[ChefSpec]: http://acrmp.github.io/chefspec/
[test-kitchen]: https://github.com/opscode/test-kitchen



# License and Maintainer

Maintainer:: IBM

License:: Apache 2.0

