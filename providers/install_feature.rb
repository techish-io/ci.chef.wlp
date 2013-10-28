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

action :install do
  if new_resource.location =~ /:\/\//
    location_uri = ::URI.parse(new_resource.location)
    location_filename = ::File.basename(location_uri.path)
    location = "#{Chef::Config[:file_cache_path]}/#{location_filename}"
    remote_file location do
      source new_resource.location
      user node[:wlp][:user]
      group node[:wlp][:group]
    end
  else
    location = new_resource.location
  end
  command = "#{@utils.installDirectory}/bin/featureManager install --when-file-exists=ignore"
  command << " --to=#{new_resource.to}"
  if new_resource.accept_license
    command << " --acceptLicense"
  end
  command << " #{location}"
  execute command do
    command command
    user node[:wlp][:user]
    group node[:wlp][:group]
    returns [0, 22]
  end
end

private 

def load_current_resource
  @utils = Liberty::Utils.new(node)
end
