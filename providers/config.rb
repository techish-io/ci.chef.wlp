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

action :create do
  update(new_resource)
end

action :create_if_missing do
  if ::File.exists?(new_resource.file)
    Chef::Log.info "#{@new_resource.file} already exists - nothing to do."
  else
    update(new_resource)
  end
end

private 

def load_current_resource
  @utils = Liberty::Utils.new(node)
end

def update(new_resource) 
  new_contents = []
  generate_xml("", "server", new_resource.config, new_contents)

  # write tmp file
  tmp_file = "#{new_resource.file}.tmp"
  out = ::File.open(tmp_file, "w")
  out.write(new_contents.join("\n"))
  out.close()
  @utils.chown(tmp_file)

  if compare(new_resource.file, tmp_file)
    # same - delete tmp file
    ::FileUtils.rm(tmp_file)
    Chef::Log.info "#{@new_resource.file} is up-to-date."
  else
    # not same - rename tmp file
    Chef::Log.info "Generating #{@new_resource.file}."
    ::FileUtils.mv(tmp_file, new_resource.file, :force => true)
    new_resource.updated_by_last_action(true)
  end
end

def compare(old_file, new_file)
  # just compare files directly
  if ::File.exists?(old_file)
    return ::FileUtils.cmp(old_file, new_file)
  else
    return false
  end
end

def generate_xml(indent, name, map, output)
  
  attributes = {}
  elements = {}

  map.each_pair do |key, value|
    if value.is_a?(Hash)
      elements[key] = value
    elsif value.is_a?(Array)
      elements[key] = value
    else
      attributes[key] = value
    end
  end

  line = "<#{name}"
  attributes.each_pair do |key, value|
    line << " #{key}=\"#{evaluate_value(value)}\""
  end

  if !elements.empty?
    line << ">"
    output <<  "#{indent}#{line}"
    
    next_indent = "  #{indent}"
    elements.each_pair do |key, value|
      if value.is_a?(Hash)
        generate_xml(next_indent, key, value, output)
      elsif value.is_a?(Array)
        if value.empty?
           output << "#{next_indent}<#{key}/>"
        elsif value.first.is_a?(Hash)
          value.each do |item|
            generate_xml(next_indent, key, item, output)
          end
        else 
          value.each do |item|
            output << "#{next_indent}<#{key}>#{evaluate_value(item)}</#{key}>"
          end
        end
      end
    end

    output << "#{indent}</#{name}>"
  else
    line << "/>"
    output << "#{indent}#{line}"
  end

end

def evaluate_value(value) 
  if value.is_a?(Proc)
    return value.call
  else
    return value
  end
end
