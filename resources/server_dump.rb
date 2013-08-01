actions :run

attribute :server_name, :kind_of => String, :name_attribute => true
attribute :archive, :kind_of => String
attribute :types, :kind_of => Array, :default => []

default_action :run
