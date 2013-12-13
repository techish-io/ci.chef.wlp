# Cookbook Name:: wlp
# Attributes:: default
#
# (C) Copyright IBM Corporation 2013.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# The 'Installable package (InstallAnywhere)' binary installer for IBM JDK requires "rpm" package on Ubuntu.
# Work-around for https://tickets.opscode.com/browse/COOK-3764.
#
jdk_uri = ::URI.parse(node['java']['ibm']['url'])
jdk_filename = ::File.basename(jdk_uri.path)
if node['java']['install_flavor'] == "ibm" && 
    platform_family?('debian') &&
    jdk_filename =~ /\.bin$/ && 
    jdk_filename !~ /archive/
  package "rpm" do
    action :install
  end
end

include_recipe "java"

#
# The recipe for IBM JDK does not call 'update-java-alternatives' to expose Java tools on the path.
# Work-around for https://tickets.opscode.com/browse/COOK-3488.
#
if node['java']['install_flavor'] == "ibm" && platform_family?('debian', 'rhel', 'fedora')

  bin_cmds = [ "java", "javac", "javadoc", "javah", "javap", "javaws", "jconsole", "jar", "jarsigner",
               "jrunscript", "keytool", "native2ascii", "policytool", "rmic", "rmid", "rmiregistry",
               "idlj", "appletviewer", "apt", "jdb", "jdmpview", "jcontrol", "extcheck", "ControlPanel",
               "javaw", "schemagen", "serialver", "tnameserv", "wsgen", "wsimport", "xjc" ]

  java_home = node['java']['java_home']
  
  bin_cmds.each do | cmd |
    bash "update-java-alternatives for #{cmd}" do
      code <<-EOH.gsub(/^\s+/, '')
        update-alternatives --install /usr/bin/#{cmd} #{cmd} #{java_home}/bin/#{cmd} 1061 && \
        update-alternatives --set #{cmd} #{java_home}/bin/#{cmd}
      EOH
      only_if { ::File.exist?("#{java_home}/bin/#{cmd}") }
      not_if "update-alternatives --display #{cmd} | grep #{java_home}/bin/#{cmd}"
    end
  end

end
