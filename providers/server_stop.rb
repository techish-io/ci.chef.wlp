action :run do
  server_name = @new_resource.server_name
  wlp_server "stop #{server_name}" do
    server_name server_name
    action :stop
  end
end
