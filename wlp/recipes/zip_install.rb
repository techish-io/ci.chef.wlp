install_dir = "#{node['wlp']['base_dir']}/wlp"

zip_uri = ::URI.parse("#{node['wlp']['zip']['url']}")
zip_file = ::File.basename(zip_uri.path)

remote_file "#{Chef::Config[:file_cache_path]}/#{zip_file}" do
  source node['wlp']['zip']['url']
  user node['wlp']['user']
  group node['wlp']['group']
  not_if { ::File.exists?(install_dir) }
end

package 'unzip'

execute "install #{zip_file}" do
  cwd node['wlp']['base_dir']
  command "unzip #{Chef::Config[:file_cache_path]}/#{zip_file}" 
  user node['wlp']['user']
  group node['wlp']['group']
  not_if { ::File.exists?(install_dir) }
end
