# TODO: Replace by a library call?
action :run do
  server_name = @new_resource.server_name
  Chef::Log.info "Packaging #{server_name}"
  args = "package #{new_resource.server_name}"
  archive = @new_resource.archive
  if archive
    args << " --archive=#{archive}"
  end
  type = @new_resource.type
  if type
    args << " --include=#{type}"
  end
  execute "bin/server #{args}" do
    command "#{node['wlp']['base_dir']}/wlp/bin/server #{args}"
    user node['wlp']['user']
    group node['wlp']['group']
  end
end
