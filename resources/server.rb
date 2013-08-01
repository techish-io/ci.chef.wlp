actions :start, :stop, :create, :dump, :package

attribute :server_name, :kind_of => String, :name_attribute => true
attribute :options, :kind_of => String, :default => nil

default_action :start
