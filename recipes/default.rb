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
Installs WebSphere Application Server Liberty Profile. Liberty profile can be 
installed using jar file archives or from a zip file based on the `node[:wlp][:install_method]` setting.
#>
=end

wlp_user = node[:wlp][:user]
wlp_group = node[:wlp][:group]
wlp_base_dir = node[:wlp][:base_dir]

# Don't create 'root' group - allows execution as root
if wlp_group != "root"
  group wlp_group do
  end
end

# Don't create 'root' user - allows execution as root
if wlp_user != "root"
  user wlp_user do
    comment 'Liberty Profile Server'
    gid wlp_group
    home wlp_base_dir
    shell '/bin/bash'
    system true
  end
end

directory wlp_base_dir do
  group wlp_group
  owner wlp_user
  mode "0755"
  recursive true
end

# Install java if requested
include_recipe "java" if node[:wlp][:install_java]

include_recipe "wlp::#{node[:wlp][:install_method]}_install"

wlp_user_dir = node[:wlp][:user_dir]
if wlp_user_dir
    # Ensure the user directory is created
    directory wlp_user_dir do
      group wlp_group
      owner wlp_user
      mode "0755"
      recursive true
    end
    
    # Set WLP_USER_DIR in etc/server.env
    wlp_server_env "set_user_dir" do
      properties "WLP_USER_DIR" => node[:wlp][:user_dir]
      action :set
    end
end
