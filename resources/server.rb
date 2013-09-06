# Cookbook Name:: wlp
# Attributes:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

=begin
#<
Provides operations for creating, starting, stopping, and destroying Liberty profile server instances.

@action create  Creates server instance.
@action destroy Destroys server instance.
@action start   Creates and starts the server instance (as an OS service). 
@action stop    Stops the server instance (via an OS service).

@section Examples
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
#>
=end
actions :start, :stop, :create, :destroy

#<> @attribute server_name Name of the server instance.
attribute :server_name, :kind_of => String, :name_attribute => true

attribute :template, :kind_of => String, :default => nil

#<> @attribute jvmOptions Instance-specific JVM options. 
attribute :jvmOptions, :kind_of => Array, :default => []

#<> @attribute serverEnv Instance-specific server environment properties. 
attribute :serverEnv, :kind_of => Hash, :default => {}

#<> @attribute clean Clean all cached information when starting the server instance.
attribute :clean, :kind_of => [TrueClass, FalseClass], :default => false

default_action :start

