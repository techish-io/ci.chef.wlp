action :run do
  server_name = @new_resource.server_name
  Chef::Log.info "Dumping #{server_name}"
  args = ""
  archive = @new_resource.archive
  if archive
    args << " --archive=#{archive}"
  end
  types = @new_resource.types
  if types && !types.empty?
    args << " --include=#{types.join(",")}"
  end
  wlp_server "dump #{server_name}" do
    server_name server_name
    action :dump
    options args
  end
end
