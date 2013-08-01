actions :run

attribute :server_name, :kind_of => String, :name_attribute => true
attribute :clean, :kind_of => [TrueClass, FalseClass], :default => false

default_action :run
