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

default[:wlp][:user] = "wlp"
default[:wlp][:group] = "wlp-admin"

default[:wlp][:base_dir] = "/opt/was/liberty"

# Set user configuration directory (wlp.user.dir). Set to 'nil' to use default location.
default[:wlp][:user_dir] = nil

# Install method - set it to 'archive' or 'zip'
default[:wlp][:install_method] = "archive"

default[:wlp][:archive][:base_url] = "http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.0/"

default[:wlp][:archive][:runtime][:url] = "#{node[:wlp][:archive][:base_url]}/wlp-developers-runtime-8.5.5.0.jar"
default[:wlp][:archive][:runtime][:checksum] = '4032747299111a580a9ef476d539fb0f67bf6c98894e01db4555d94d35bb5175'

default[:wlp][:archive][:extended][:url] = "#{node[:wlp][:archive][:base_url]}/wlp-developers-extended-8.5.5.0.jar"
default[:wlp][:archive][:extended][:checksum] = 'b3df906bd7ddeafa58121c96577ac08054208f16cb874a8684b6b132267e23a0'
default[:wlp][:archive][:extended][:install] = true

default[:wlp][:archive][:extras][:url] = "#{node[:wlp][:archive][:base_url]}/wlp-developers-extras-8.5.5.0.jar"
default[:wlp][:archive][:extras][:checksum] = '7ff244a92260f032ad67733070df7f581a1a97628e01aebde808148b981396d3'
default[:wlp][:archive][:extras][:install] = false
default[:wlp][:archive][:extras][:base_dir] = "#{node[:wlp][:base_dir]}/extras"

default[:wlp][:archive][:accept_license] = false

# Must specify zip file URL if performing zip installation
default[:wlp][:zip][:url] = nil
