
wlp_user = node['wlp']['user']
wlp_group = node['wlp']['group']
wlp_base_dir = node['wlp']['base_dir']

group wlp_group do
end

user wlp_user do
  comment 'Liberty Profile Server'
  gid wlp_group
  home wlp_base_dir
  shell '/bin/bash'
  system true
end

directory wlp_base_dir do
  group wlp_group
  owner wlp_user
  mode "0755"
  recursive true
end

include_recipe "wlp::#{node['wlp']['install_method']}_install"
