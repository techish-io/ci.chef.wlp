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

action :add do
  if new_resource.properties.kind_of?(Array)
    raise "Properties must be specified as a hash"
  else
    new_resource.properties.each do | name, value |
      @serverEnv.add(name, value)
    end
  end
  
  new_resource.updated_by_last_action(true) if @serverEnv.save
end

action :remove do
  if new_resource.properties.kind_of?(Array)
    new_resource.properties.each do | name |
      @serverEnv.remove(name)
    end
  else
    raise "Properties must be specified as an array"
  end
  
  new_resource.updated_by_last_action(true) if @serverEnv.save
end

action :set do
  if new_resource.properties.kind_of?(Array)
    raise "Properties must be specified as a hash"
  else
    @serverEnv.set(new_resource.properties)
  end
  
  new_resource.updated_by_last_action(true) if @serverEnv.save
end

def load_current_resource
  @serverEnv = Liberty::ServerEnv.new(node, new_resource.server_name)
end
