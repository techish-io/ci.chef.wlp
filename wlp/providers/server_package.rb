action :run do
  server_name = @new_resource.server_name
  Chef::Log.info "Packaging #{server_name}"
  args = ""
  archive = @new_resource.archive
  if archive
    args << " --archive=#{archive}"
  end
  type = @new_resource.type
  if type
    args << " --include=#{type}"
  end
  wlp_server "package #{server_name}" do
    server_name server_name
    action :package
    options args
  end
end
