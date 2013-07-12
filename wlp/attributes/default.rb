

default['wlp']['user'] = "wlp"
default['wlp']['group'] = "wlp-admin"

default['wlp']['base_dir'] = "/opt/was/liberty"

default['wlp']['install_method'] = "wasdev"

default['wlp']['wasdev']['base_url'] = "http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.5.0/"
default['wlp']['wasdev']['runtime_url'] = "#{node['wlp']['wasdev']['base_url']}/wlp-developers-runtime-8.5.5.0.jar"
default['wlp']['wasdev']['extended_url'] = "#{node['wlp']['wasdev']['base_url']}/wlp-developers-extended-8.5.5.0.jar"
default['wlp']['wasdev']['accept_license'] = false

default['wlp']['zip']['url'] = nil
