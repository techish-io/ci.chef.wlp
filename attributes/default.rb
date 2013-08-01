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

default['wlp']['user'] = "wlp"
default['wlp']['group'] = "wlp-admin"

default['wlp']['base_dir'] = "/opt/was/liberty"

default['wlp']['install_method'] = "wasdev"

default['wlp']['wasdev']['base_url'] = "http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.0/"

default['wlp']['wasdev']['runtime_url'] = "#{node['wlp']['wasdev']['base_url']}/wlp-developers-runtime-8.5.5.0.jar"
default['wlp']['wasdev']['runtime_checksum'] = '4032747299111a580a9ef476d539fb0f67bf6c98894e01db4555d94d35bb5175'

default['wlp']['wasdev']['extended_url'] = "#{node['wlp']['wasdev']['base_url']}/wlp-developers-extended-8.5.5.0.jar"
default['wlp']['wasdev']['extended_checksum'] = 'b3df906bd7ddeafa58121c96577ac08054208f16cb874a8684b6b132267e23a0'

default['wlp']['wasdev']['extras_url'] = "#{node['wlp']['wasdev']['base_url']}/wlp-developers-extras-8.5.5.0.jar"
default['wlp']['wasdev']['extras_checksum'] = '7ff244a92260f032ad67733070df7f581a1a97628e01aebde808148b981396d3'

default['wlp']['wasdev']['accept_license'] = false

default['wlp']['zip']['url'] = nil
