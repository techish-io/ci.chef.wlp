define :install_sample do

  sample_location = params[:location]
  sample_server = params[:server_name]

  include_recipe 'wlp::default'

  full_url = "https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/samples/#{sample_location}"
  
  sample_uri = ::URI.parse(full_url)
  sample_file = ::File.basename(sample_uri.path)

  sample_dir = "#{node['wlp']['base_dir']}/wlp/usr/servers/#{sample_server}"

  remote_file "#{Chef::Config[:file_cache_path]}/#{sample_file}" do
    source full_url
    user node['wlp']['user']
    group node['wlp']['group']
    not_if { ::File.exists?(sample_dir) }
  end

  execute "install #{sample_file}" do
    cwd node['wlp']['base_dir']
    command "java -jar #{Chef::Config[:file_cache_path]}/#{sample_file} --acceptLicense #{node['wlp']['base_dir']} --downloadDependencies" 
    user node['wlp']['user']
    group node['wlp']['group']
    not_if { ::File.exists?(sample_dir) }
  end

end
