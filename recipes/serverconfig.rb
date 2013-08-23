# Cookbook Name:: wlp
# Recipe:: serverconfig
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
#

wlp_user = node[:wlp][:user]
wlp_group = node[:wlp][:group]
wlp_base_dir = node[:wlp][:base_dir]

wlp_user_dir = node[:wlp][:user_dir]
if !wlp_user_dir
  wlp_user_dir = "#{wlp_base_dir}" + "/wlp/usr"
end

node[:wlp][:servers].each_pair do |key, value|
  if value["enabled"] == true

    directory "#{wlp_user_dir}/servers/#{value[:servername]}" do
      mode   "0775"
      owner  "#{wlp_user}"
      group  "#{wlp_group}"
    end

    # First render the server.xml
    template "#{wlp_user_dir}/servers/#{value[:servername]}/server.xml" do
      source "server.xml.erb"
      mode   "0775"
      owner  "#{wlp_user}"
      group  "#{wlp_group}"
      variables ({
        :servername => value["servername"],
        :description => value["description"],
        :features => value["features"],
        :httpendpoints => value["httpendpoints"],
        :includes => value["includes"]
      })
    end
    # Add more files to be rendered here
  end
end
