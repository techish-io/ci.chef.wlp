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

require 'minitest/spec'
require 'rexml/document'

describe 'recipe::wlp_test::app' do

  it "server is created" do
    file("#{node[:wlp][:user_dir]}/servers/jsp-examples/server.xml").must_exist
  end

  it "boots on startup" do
    service("wlp-jsp-examples").must_be_enabled
  end

  it "runs as a daemon" do
    # Work-around as described in https://github.com/calavera/minitest-chef-handler/issues/22
    s = service("wlp-jsp-examples")
    s.supports([:status])
    s.run_context = run_context
    ::Chef::Platform.provider_for_resource(s).load_current_resource.must_be_running
  end

  def send_request
    for i in 1..10
      begin
        url = URI.parse('http://localhost:9080/jsp-examples/jsp2/el/basic-arithmetic.jsp')
        req = Net::HTTP::Get.new(url.path)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        if res.code == "200"
          return res
        else
          # keep going
        end
      rescue
        # keep going
      end
      sleep 2
    end
    return nil
  end
  
  it "application is running" do
    res = send_request

    res.wont_be_nil "Failed to access the application"
    res.code.must_equal "200"
    res.body.must_include "Basic Arithmetic"
  end

  it "contains encoded password" do
    doc = REXML::Document.new(File.open("#{node[:wlp][:user_dir]}/servers/jsp-examples/server.xml"))
    keystore = doc.root.elements["keyStore[@id='defaultKeyStore']"]
    keystore.wont_be_nil
    keystore.attributes["password"].must_equal "{xor}Lz4sLCgwLTs="
  end

end
