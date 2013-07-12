actions :run

attribute :server_name, :kind_of => String, :name_attribute => true
attribute :template, :kind_of => String, :default => nil

default_action :run
