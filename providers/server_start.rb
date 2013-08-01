action :run do
  server_name = @new_resource.server_name
  Chef::Log.info "Starting #{server_name}"
  args = ""
  if @new_resource.clean
    args << " --clean"
  end
  wlp_server "start #{server_name}" do
    server_name server_name
    action :start
    options args
  end
end
