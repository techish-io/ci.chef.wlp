require 'rake/clean'

sandbox_dir = ".sandbox"

CLEAN.include(sandbox_dir)

task :default => :all

task :all => [:knife_test, :foodcritic, :rspec]

desc "Runs 'knfie cookbook test'"
task :knife_test do
  sh "bundle exec knife cookbook test -o .. #{cookbook_name}"
end

desc "Runs 'foodcritic'"
task :foodcritic do
  sh "bundle exec foodcritic ."
end

desc "Runs 'rspec'"
task :rspec do
  cookbooks_path = "#{sandbox_dir}/cookbooks"
  sh "bundle exec berks install --path=#{cookbooks_path}"
  sh "bundle exec rspec #{cookbooks_path}/wlp/spec"
end




def cookbook_name
  File.basename(File.dirname(__FILE__))
end
