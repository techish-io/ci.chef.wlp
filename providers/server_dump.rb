# TODO: Replace by a library call?
action :run do
  server_name = @new_resource.server_name
  Chef::Log.info "Dumping #{server_name}"
  args = "dump #{new_resource.server_name}"
  archive = @new_resource.archive
  if archive
    args << " --archive=#{archive}"
  end
  types = @new_resource.types
  if types && !types.empty?
    args << " --include=#{types.join(",")}"
  end
  execute "bin/server #{args}" do
    command "#{node['wlp']['base_dir']}/wlp/bin/server #{args}"
    user node['wlp']['user']
    group node['wlp']['group']
  end
end
