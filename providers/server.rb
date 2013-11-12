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
  if @utils.serverDirectoryExists?(new_resource.server_name)
    Chef::Log.info "#{new_resource.server_name} already exists - nothing to do."
  else
    update(new_resource)
  end
end

def update(new_resource)
  servers_dir = @utils.serversDirectory

  directory "#{servers_dir}/#{new_resource.server_name}" do
    mode   "0775"
    user node[:wlp][:user]
    group node[:wlp][:group]
    recursive true
  end

  %w{apps dropins}.each do | name |
    directory "#{servers_dir}/#{new_resource.server_name}/#{name}" do
      mode   "0775"
      user node[:wlp][:user]
      group node[:wlp][:group]
    end
  end

  config = new_resource.config || node[:wlp][:config][:basic]
  wlp_config "#{servers_dir}/#{new_resource.server_name}/server.xml" do
    config config
  end
  
  wlp_jvm_options "jvm.options for #{new_resource.server_name}" do
    server_name new_resource.server_name
    options new_resource.jvmOptions
    action :set
  end

  wlp_server_env "server.env for #{new_resource.server_name}" do
    server_name new_resource.server_name
    properties new_resource.serverEnv
    action :set
  end

  wlp_bootstrap_properties "bootstrap.properties for #{new_resource.server_name}" do
    server_name new_resource.server_name
    properties new_resource.bootstrapProperties
    action :set
  end

  new_resource.updated_by_last_action(true)
end

action :start do

  service "wlp-#{new_resource.server_name}" do
    supports :start => true, :restart => true, :stop => true, :status => true
    action :nothing
  end

  installDir = @utils.installDirectory

  template "/etc/init.d/wlp-#{new_resource.server_name}" do
    cookbook "wlp"
    source "init.d.erb"
    mode "0755"
    owner "root"
    group "root"

    variables(
      "serverName" => new_resource.server_name,
      "cleanStart" => new_resource.clean, 
      "installDir" => installDir
    )

    notifies :restart, "service[wlp-#{new_resource.server_name}]", :delayed
  end

  service "wlp-#{new_resource.server_name}" do
    action [ :enable, :start ]
  end

end


action :stop do
  serverDirectory = @utils.serverDirectory(new_resource.server_name)
  if ::File.exists?(serverDirectory)
    service "wlp-#{new_resource.server_name}" do
      action [ :stop, :disable ]
    end
  end
end


action :destroy do
  serverDirectory = @utils.serverDirectory(new_resource.server_name)
  if ::File.exists?(serverDirectory)
    # try to stop it first
    service "wlp-#{new_resource.server_name}" do
      action [ :stop, :disable ]
    end

    # delete the directory
    directory serverDirectory do
      recursive true
      action :delete
    end
  end
end

def load_current_resource
  @utils = Liberty::Utils.new(node)
end
