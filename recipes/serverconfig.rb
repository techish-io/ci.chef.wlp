# Cookbook Name:: wlp
# Attributes:: serverconfig
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

=begin
#<
Creates Liberty profile server instance for each `node[:wlp][:servers][<server_name>]` definition.
The following definition creates a simple `airport` server instance:
```ruby
node[:wlp][:servers][:airport] = {
  "enabled" => true,
  "servername" => "airport",
  "description" => "Airport Demo App",
  "features" => [ "jsp-2.2" ],
  "httpEndpoints" => [
    {
      "id" => "defaultHttpEndpoint",
      "host" => "*",
      "httpPort" => "9080",
      "httpsPort" => "9443"
    }
  ]
}
```
#>
=end

wlp_user = node[:wlp][:user]
wlp_group = node[:wlp][:group]

utils = Liberty::Utils.new(node)
servers_dir = utils.serversDirectory

node[:wlp][:servers].each_pair do |key, value|
  if value["enabled"] == true

    directory "#{servers_dir}/#{value[:servername]}" do
      mode   "0775"
      owner  wlp_user
      group  wlp_group
    end

    # First render the server.xml
    template "#{servers_dir}/#{value[:servername]}/server.xml" do
      source "server.xml.erb"
      mode   "0775"
      owner  wlp_user
      group  wlp_group
      variables ({
        :servername => value["servername"],
        :description => value["description"],
        :features => value["features"],
        :httpEndpoints => value["httpEndpoints"],
        :includes => value["includes"],
        :applications_xml => value["applicationsxml"]
      })
    end
    # Add more files to be rendered here
  end
end
