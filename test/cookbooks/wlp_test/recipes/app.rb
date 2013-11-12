# Cookbook Name:: wlp_test
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

include_recipe "wlp::default"

server_name = "jsp-examples"
app_file = "jsp-examples-war-3.0-M1.war"

# create server
wlp_server server_name do
  config ({
            "featureManager" => {
              "feature" => [ "jsp-2.2" ]
            },
            "httpEndpoint" => {
              "id" => "defaultHttpEndpoint",
              "host" => "*",
              "httpPort" => "${default.http.port}",
              "httpsPort" => "${default.https.port}"
            },
            "application" => {
              "id" => "jsp-examples",
              "name" => "jsp-examples",
              "type" => "war",
              "location" => app_file
            },
            "keyStore" => {
              "id" => "defaultKeyStore",
              "password" => lambda { Liberty::SecurityHelper.new(node).encode("password") }
            }
          })
  bootstrapProperties "default.http.port" => "9080", "default.https.port" => "9443"
  action :create
end

utils = Liberty::Utils.new(node)
apps_dir = "#{utils.serversDirectory}/#{server_name}/apps"

# download sample
source = "http://repo1.maven.org/maven2/org/apache/geronimo/samples/jsp-examples-war/3.0-M1/jsp-examples-war-3.0-M1.war"
remote_file "#{apps_dir}/#{app_file}" do
  source source
  user node[:wlp][:user]
  group node[:wlp][:group]
end

# start server
wlp_server server_name do
  action :start
end
