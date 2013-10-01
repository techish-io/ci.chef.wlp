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

module Liberty
  class Utils
    
    def initialize(node)
      @node = node.to_hash
    end

    def installDirectory
      return "#{@node['wlp']['base_dir']}/wlp"
    end

    def userDirectory
      return @node['wlp']['user_dir'] || "#{installDirectory}/usr"
    end
    
    def serversDirectory
      return "#{userDirectory}/servers"
    end

    def serverDirectory(server_name)
      return "#{serversDirectory}/#{server_name}"
    end

    def serverDirectoryExists?(server_name)
      return ::File.exists?(serverDirectory(server_name))
    end
    
    def user
      return @node['wlp']['user']
    end
    
    def group
      return @node['wlp']['group']
    end

    def createParentDirectory(dir)
      if ! File.exists?(dir)
        createParentDirectory(File.dirname(dir))
        FileUtils.mkdir(dir);
        chown(dir)
      end
    end

    def chown(file)
      FileUtils.chown(user, group, file)
    end
    
  end
end
