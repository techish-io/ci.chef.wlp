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

describe 'recipe::wlp_test::basic' do

  it "runtime is installed" do
    directory("#{node[:wlp][:base_dir]}/wlp").must_exist
  end

  it "extended is installed" do
    directory("#{node[:wlp][:base_dir]}/wlp/bin/jaxws").must_exist
  end

  it "extras is not installed" do
    directory("#{node[:wlp][:archive][:extras][:base_dir]}/wlp").wont_exist
  end

  it "server is created" do
    file("#{node[:wlp][:base_dir]}/wlp/usr/servers/testServer/server.xml").must_exist
  end

  it "boots on startup" do
    service("wlp-testServer").must_be_enabled
  end

  it "runs as a daemon" do
    # Work-around as described in https://github.com/calavera/minitest-chef-handler/issues/22
    s = service("wlp-testServer")
    s.supports([:status])
    s.run_context = run_context
    ::Chef::Platform.provider_for_resource(s).load_current_resource.must_be_running
  end

end
