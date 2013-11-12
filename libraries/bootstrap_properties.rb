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
  class BootstrapProperties
    
    def initialize(node, server_name)
      @utils = Utils.new(node)
      @server_name = server_name
      @modified = false

      if server_name.nil?
        raise "Server name must be specified"
      end
      if !@utils.serverDirectoryExists?(server_name)
        raise "Server does not exist: #{server_name}"
      end

      file = bootstrapPropertiesFile()

      @properties = {}

      if ::File.exists?(file)
        fileContents = ::File.readlines(file)
        fileContents.each do | line |
          line.strip!
          if !line.empty? && !line.start_with?("#")
            pos = line.index("=")
            if pos
              name = line[0..pos-1].strip
              value = line[pos+1..-1].strip
              @properties[name] = value
            end
          end
        end
      end
    end

    def bootstrapPropertiesFile()
      return "#{@utils.serversDirectory}/#{@server_name}/bootstrap.properties"
    end

    def properties
      return @properties
    end
    
    def modified
      return @modified
    end

    def set(properties)
      properties = properties || {}

      if !containsAll(properties)
        @properties = properties
        @modified = true
      end
    end
    
    def containsAll(properties)
      if @properties.size() == properties.size()
        @properties.each do | key, value |
          if !properties.has_key?(key) || properties[key] != value
            return false
          end
        end
        return true
      else
        return false
      end
    end

    def add(name, value)
      if value == get(name)
        return false
      else 
        @properties[name] = value
        @modified = true
        return true
      end
    end

    def remove(name)
      if @properties.delete(name)
        @modified = true
        return true
      else 
        return false
      end
    end

    def get(name)
      return @properties[name]
    end

    def save()
      if @modified
        file = bootstrapPropertiesFile()

        out = ::File.open(file, "w")
        @properties.each do | key, value |
          line = "#{key}=#{value}\n"
          out.write(line)
        end
        out.close()

        @utils.chown(file)

        return true
      else
        return false
      end
    end

  end
end
