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
  new_resource.options.each do | value |
    @jvmOptions.add(value)
  end
  
  new_resource.updated_by_last_action(true) if @jvmOptions.save
end

action :remove do
  new_resource.options.each do | value |
    @jvmOptions.remove(value)
  end
  
  new_resource.updated_by_last_action(true) if @jvmOptions.save
end

action :set do
  @jvmOptions.set(new_resource.options)
  
  new_resource.updated_by_last_action(true) if @jvmOptions.save
end

def load_current_resource
  @jvmOptions = Liberty::JvmOptions.new(node, new_resource.server_name)
end
