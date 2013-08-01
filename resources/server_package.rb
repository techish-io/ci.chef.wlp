actions :run

attribute :server_name, :kind_of => String, :name_attribute => true
attribute :archive, :kind_of => String
attribute :type, :equal_to => [:all, :usr, :minify]

default_action :run
