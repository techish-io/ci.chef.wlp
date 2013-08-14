actions :start, :stop, :create, :destroy

attribute :server_name, :kind_of => String, :name_attribute => true

attribute :template, :kind_of => String, :default => nil
attribute :jvmOptions, :kind_of => Array, :default => []
attribute :serverEnv, :kind_of => Hash, :default => {}
attribute :clean, :kind_of => [TrueClass, FalseClass], :default => false

default_action :start
