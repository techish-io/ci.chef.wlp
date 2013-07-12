unless node['wlp']['wasdev']['accept_license']
  raise "You must accept license to install WebSphere Application Server Liberty Profile."
end

runtime_dir = "#{node['wlp']['base_dir']}/wlp"
runtime_uri = ::URI.parse("#{node['wlp']['wasdev']['runtime_url']}")
runtime_file = ::File.basename(runtime_uri.path)

remote_file "#{Chef::Config[:file_cache_path]}/#{runtime_file}" do
  source node['wlp']['wasdev']['runtime_url']
  user node['wlp']['user']
  group node['wlp']['group']
  not_if { ::File.exists?(runtime_dir) }
end

extended_dir = "#{node['wlp']['base_dir']}/wlp/bin/jaxws"

if node['wlp']['wasdev']['extended_url']
  extended_uri = ::URI.parse("#{node['wlp']['wasdev']['extended_url']}")
  extended_file = ::File.basename(extended_uri.path)
  remote_file "#{Chef::Config[:file_cache_path]}/#{extended_file}" do
    source node['wlp']['wasdev']['extended_url']
    user node['wlp']['user']
    group node['wlp']['group']
    not_if { ::File.exists?(extended_dir) }
  end
end

include_recipe "java"

execute "install #{runtime_file}" do
  cwd node['wlp']['base_dir']
  command "java -jar #{Chef::Config[:file_cache_path]}/#{runtime_file} --acceptLicense #{node['wlp']['base_dir']}" 
  user node['wlp']['user']
  group node['wlp']['group']
  not_if { ::File.exists?(runtime_dir) }
end

if node['wlp']['wasdev']['extended_url']
  execute "install #{extended_file}" do
    cwd node['wlp']['base_dir']
    command "java -jar #{Chef::Config[:file_cache_path]}/#{extended_file} --acceptLicense #{node['wlp']['base_dir']}" 
    user node['wlp']['user']
    group node['wlp']['group']
    not_if { ::File.exists?(extended_dir) }
  end
end
