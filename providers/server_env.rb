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

action :set do
  if new_resource.properties.kind_of?(Array)
    raise "Properties must be specified as a hash"
  else
    new_resource.properties.each do | name, value |
      @serverEnv.set(name, value)
    end
  end
  
  new_resource.updated_by_last_action(true) if @serverEnv.save
end

action :unset do
  if new_resource.properties.kind_of?(Array)
    new_resource.properties.each do | name |
      @serverEnv.unset(name)
    end
  else
    raise "Properties must be specified as an array"
  end
  
  new_resource.updated_by_last_action(true) if @serverEnv.save
end

def load_current_resource
  @serverEnv = Liberty::ServerEnv.new(node, new_resource.server_name)
end
