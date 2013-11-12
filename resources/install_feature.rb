# Cookbook Name:: wlp
# Attributes:: default
#
# (C) Copyright IBM Corporation 2013.
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
Installs a feature from an enterprise subsystem archive (ESA) file.

@action install Installs a feature using .esa file.

@section Examples
```ruby
wlp_install_feature "mongodb" do
  location "http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.1/com.ibm.websphere.appserver.mongodb-2.0.esa"
  accept_license true
end
```
#>
=end
actions :install

#<> @attribute location Specifies the location of the subsystem archive (ESA file) to install. Can be a file name or a URL.
attribute :location, :kind_of => String, :default => nil

#<> @attribute to Specifies where to install the feature. The feature can be installed to any configured product extension location, or as a user feature. 
attribute :to, :kind_of => String, :default => "usr"

#<> @attribute accept_license Specifies whether to accept the license terms and conditions of the feature.
attribute :accept_license, :kind_of => [TrueClass, FalseClass], :default => false

default_action :install

