action :run do
   server_dir = "#{node['wlp']['base_dir']}/wlp/usr/servers/#{new_resource.server_name}"
   if ::File.exists? server_dir
     Chef::Log.info "#{server_dir}  already exists - nothing to do."
   else
     Chef::Log.info "#{server_dir} doesn't exist - creating."

     server_name = @new_resource.server_name
     args = ""
     template = @new_resource.template
     if template
       args << " --template=#{template}"
     end
     wlp_server "create #{server_name}" do
      server_name server_name
      options args
      action :create
    end
   end
end
