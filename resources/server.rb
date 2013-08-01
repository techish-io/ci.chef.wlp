actions :start, :stop, :create

attribute :server_name, :kind_of => String, :name_attribute => true

attribute :template, :kind_of => String, :default => nil
attribute :clean, :kind_of => [TrueClass, FalseClass], :default => false

default_action :start
