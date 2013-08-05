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

wlp_user = node[:wlp][:user]
wlp_group = node[:wlp][:group]
wlp_base_dir = node[:wlp][:base_dir]

group wlp_group do
end

user wlp_user do
  comment 'Liberty Profile Server'
  gid wlp_group
  home wlp_base_dir
  shell '/bin/bash'
  system true
end

directory wlp_base_dir do
  group wlp_group
  owner wlp_user
  mode "0755"
  recursive true
end

include_recipe "wlp::#{node[:wlp][:install_method]}_install"
