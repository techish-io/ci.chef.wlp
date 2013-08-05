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

unless node[:wlp][:archive][:accept_license]
  raise "You must accept license to install WebSphere Application Server Liberty Profile."
end

runtime_dir = "#{node[:wlp][:base_dir]}/wlp"
runtime_uri = ::URI.parse(node[:wlp][:archive][:runtime][:url])
runtime_file = ::File.basename(runtime_uri.path)

# Fetch the WAS Liberty Profile runtime file
remote_file "#{Chef::Config[:file_cache_path]}/#{runtime_file}" do
  source node[:wlp][:archive][:runtime][:url]
  user node[:wlp][:user]
  group node[:wlp][:group]
  checksum node[:wlp][:archive][:runtime][:checksum]
  not_if { ::File.exists?(runtime_dir) }
end

# Used to determine whether extended archive is already installed
extended_dir = "#{node[:wlp][:base_dir]}/wlp/bin/jaxws"

# Fetch the WAS Liberty Profile extended content
if node[:wlp][:archive][:extended][:install]
  extended_uri = ::URI.parse(node[:wlp][:archive][:extended][:url])
  extended_file = ::File.basename(extended_uri.path)
  remote_file "#{Chef::Config[:file_cache_path]}/#{extended_file}" do
    source node[:wlp][:archive][:extended][:url]
    user node[:wlp][:user]
    group node[:wlp][:group]
    checksum node[:wlp][:archive][:extended][:checksum]
    not_if { ::File.exists?(extended_dir) }
  end
end

# Used to determine whether extras archive is already installed
extras_testfile = "#{node[:wlp][:archive][:extras][:base_dir]}/wlp"

# Fetch the WAS Liberty Profile extras content
if node[:wlp][:archive][:extras][:install]
  extras_uri = ::URI.parse(node[:wlp][:archive][:extras][:url])
  extras_file = ::File.basename(extras_uri.path)
  remote_file "#{Chef::Config[:file_cache_path]}/#{extras_file}" do
    source node[:wlp][:archive][:extras][:url]
    user node[:wlp][:user]
    group node[:wlp][:group]
    checksum node[:wlp][:archive][:extras][:checksum]
    not_if { ::File.exists?(extras_testfile) }
  end
end

# Install java - should we include some options in case the user wants Oracle or IBM java?
include_recipe "java"

# Install the WAS Liberty Profile
execute "install #{runtime_file}" do
  cwd node[:wlp][:base_dir]
  command "java -jar #{Chef::Config[:file_cache_path]}/#{runtime_file} --acceptLicense #{node[:wlp][:base_dir]}" 
  user node[:wlp][:user]
  group node[:wlp][:group]
  not_if { ::File.exists?(runtime_dir) }
end

# Install the WAS Liberty Profile extended content
if node[:wlp][:archive][:extended][:install]
  execute "install #{extended_file}" do
    cwd node[:wlp][:base_dir]
    command "java -jar #{Chef::Config[:file_cache_path]}/#{extended_file} --acceptLicense #{node[:wlp][:base_dir]}" 
    user node[:wlp][:user]
    group node[:wlp][:group]
    not_if { ::File.exists?(extended_dir) }
  end
end

# Install the WAS Liberty Profile extras
if node[:wlp][:archive][:extras][:install]
  execute "install #{extras_file}" do
    cwd node[:wlp][:base_dir]
    # We expand into /tmp and cp because the jar installer fails if the wlp directory already exists.
    command "java -jar #{Chef::Config[:file_cache_path]}/#{extras_file} --acceptLicense #{node[:wlp][:archive][:extras][:base_dir]}" 
    user node[:wlp][:user]
    group node[:wlp][:group]
    not_if { ::File.exists?(extras_testfile) }
  end
end
