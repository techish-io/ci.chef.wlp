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
  class JvmOptions
    
    def initialize(node, server_name = nil)
      @utils = Utils.new(node)
      @server_name = server_name
      @modified = false

      if server_name && !@utils.serverDirectoryExists?(server_name)
        raise "Server does not exist: #{server_name}"
      end

      file = optionsFile()

      @options = []

      if ::File.exists?(file)
        fileContents = ::File.readlines(file)
        fileContents.each do | line |
          line.strip!
          if !line.empty? && !line.start_with?("#")
            @options << line
          end
        end
      end
    end

    def optionsFile()
      if @server_name
        return "#{@utils.serversDirectory}/#{@server_name}/jvm.options"
      else
        return "#{@utils.installDirectory}/etc/jvm.options"
      end
    end

    def options
      return @options
    end

    def modified
      return @modified
    end

    def set(options)
      options = options || []

      if !containsAll(options)
        @options = options
        @modified = true
      end
    end
    
    def containsAll(options)
      if @options.size() == options.size()
        @options.each do | value |
          if !options.include?(value)
            return false
          end
        end
        return true
      else
        return false
      end
    end
    
    def add(option)
      if index = findOption(option)
        return false
      else 
        @options << option
        @modified = true
        return true
      end
    end

    def remove(option)
      if index = findOption(option)
        @options.delete_at(index)
        @modified = true
        return true
      else 
        return false
      end
    end

    def findOption(option)
      @options.each_with_index do | value, index |
        if option == value
          return index
        end
      end
      return nil
    end

    def save()
      if @modified
        file = optionsFile()

        # create "etc" parent directory if necessary
        if !@server_name
          @utils.createParentDirectory(::File.dirname(file))
        end

        out = ::File.open(file, "w")
        out.write(@options.join("\n"))
        out.close()

        @utils.chown(file)

        return true
      else
        return false
      end
    end

  end
end
