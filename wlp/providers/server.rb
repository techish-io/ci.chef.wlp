def server_script
  "#{node['wlp']['base_dir']}/wlp/bin/server"
end

def execute_script(operation)
  args = "#{operation} #{new_resource.server_name}"
  options = new_resource.options
  if options
    args << options
  end 
  execute "bin/server #{args}" do
    command "#{server_script} #{args}"
    user node['wlp']['user']
    group node['wlp']['group']
  end
end

action :create do
  execute_script("create")
end

action :start do
  execute_script("start")
end

action :stop do
  execute_script("stop")
end

action :dump do
  execute_script("dump")
end

action :package do
  execute_script("package")
end
