require 'chefspec'

describe 'wlp::default' do

  context "archive::basic" do
    let (:chef_run) { 
      chef_run = ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '12.04')
      chef_run.node.set['wlp']['archive']['accept_license'] = true
      chef_run.node.set['wlp']['archive']['runtime']['url'] = "http://example.com/runtime.jar"
      chef_run.node.set['wlp']['archive']['extended']['url'] = "http://example.com/extended.jar"
      chef_run.node.set['wlp']['archive']['extras']['url'] = "http://example.com/extras.jar"
      chef_run.converge 'wlp::default'
    }

    it "include archive_install" do
      expect(chef_run).to include_recipe('wlp::archive_install')
    end

    it "create group" do
      expect(chef_run).to create_group(chef_run.node['wlp']['group'])
    end

    it "create user" do
      expect(chef_run).to create_user(chef_run.node['wlp']['user'])
    end

    it "create base directory" do
      baseDir = chef_run.node['wlp']['base_dir']
      expect(chef_run).to create_directory(baseDir)
      dir = chef_run.directory(baseDir)
      expect(dir).to be_owned_by(chef_run.node['wlp']['user'], chef_run.node['wlp']['group'])
    end

    it "download runtime.jar" do
      expect(chef_run).to create_remote_file("/var/chef/cache/runtime.jar")
    end

    it "download extended.jar" do
      expect(chef_run).to create_remote_file("/var/chef/cache/extended.jar")
    end

    it "not download extras.jar" do
      expect(chef_run).not_to create_remote_file("/var/chef/cache/extras.jar")
    end

    it  "install runtime.jar" do
      expect(chef_run).to execute_command("java -jar /var/chef/cache/runtime.jar --acceptLicense #{chef_run.node['wlp']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

    it  "install extended.jar" do
      expect(chef_run).to execute_command("java -jar /var/chef/cache/extended.jar --acceptLicense #{chef_run.node['wlp']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

    it  "not install extras.jar" do
      expect(chef_run).not_to execute_command("java -jar /var/chef/cache/extras.jar --acceptLicense #{chef_run.node['wlp']['archive']['extras']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

  end

  ### Install runtime without extended but with extras archive and non-default user/group"
  context "archive::basic -extended and +extras" do
    let (:chef_run) { 
      chef_run = ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '12.04')
      chef_run.node.set['wlp']['user'] = "liberty"
      chef_run.node.set['wlp']['group'] = "admin"
      chef_run.node.set['wlp']['archive']['accept_license'] = true
      chef_run.node.set['wlp']['archive']['runtime']['url'] = "http://example.com/runtime.jar"
      chef_run.node.set['wlp']['archive']['extended']['url'] = "http://example.com/extended.jar"
      chef_run.node.set['wlp']['archive']['extended']['install'] = false
      chef_run.node.set['wlp']['archive']['extras']['url'] = "http://example.com/extras.jar"
      chef_run.node.set['wlp']['archive']['extras']['install'] = true
      chef_run.converge 'wlp::default'
    }

    it "include archive_install" do
      expect(chef_run).to include_recipe('wlp::archive_install')
    end

    it "create group" do
      expect(chef_run).to create_group(chef_run.node['wlp']['group'])
    end

    it "create user" do
      expect(chef_run).to create_user(chef_run.node['wlp']['user'])
    end

    it "create base directory" do
      baseDir = chef_run.node['wlp']['base_dir']
      expect(chef_run).to create_directory(baseDir)
      dir = chef_run.directory(baseDir)
      expect(dir).to be_owned_by(chef_run.node['wlp']['user'], chef_run.node['wlp']['group'])
    end

    it "download runtime.jar" do
      expect(chef_run).to create_remote_file("/var/chef/cache/runtime.jar")
    end

    it "not download extended.jar" do
      expect(chef_run).not_to create_remote_file("/var/chef/cache/extended.jar")
    end

    it "download extras.jar" do
      expect(chef_run).to create_remote_file("/var/chef/cache/extras.jar")
    end

    it  "install runtime.jar" do
      expect(chef_run).to execute_command("java -jar /var/chef/cache/runtime.jar --acceptLicense #{chef_run.node['wlp']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

    it  "not install extended.jar" do
      expect(chef_run).not_to execute_command("java -jar /var/chef/cache/extended.jar --acceptLicense #{chef_run.node['wlp']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

    it  "install extras.jar" do
      expect(chef_run).to execute_command("java -jar /var/chef/cache/extras.jar --acceptLicense #{chef_run.node['wlp']['archive']['extras']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

  end

  ### Install runtime, extended, extras "
  context "archive:all" do
    let (:chef_run) { 
      chef_run = ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '12.04')
      chef_run.node.set['wlp']['archive']['accept_license'] = true
      chef_run.node.set['wlp']['base_dir'] = "/liberty"
      chef_run.node.set['wlp']['user_dir'] = "/liberty/config"
      chef_run.node.set['wlp']['archive']['runtime']['url'] = "http://example.com/runtime.jar"
      chef_run.node.set['wlp']['archive']['extended']['url'] = "http://example.com/extended.jar"
      chef_run.node.set['wlp']['archive']['extended']['install'] = true
      chef_run.node.set['wlp']['archive']['extras']['url'] = "http://example.com/extras.jar"
      chef_run.node.set['wlp']['archive']['extras']['install'] = true
      chef_run.node.set['wlp']['archive']['extras']['base_dir'] = "/liberty/extras"
      chef_run.converge 'wlp::default'
    }

    it "include archive_install" do
      expect(chef_run).to include_recipe('wlp::archive_install')
    end

    it "create group" do
      expect(chef_run).to create_group(chef_run.node['wlp']['group'])
    end

    it "create user" do
      expect(chef_run).to create_user(chef_run.node['wlp']['user'])
    end

    it "create base directory" do
      baseDir = chef_run.node['wlp']['base_dir']
      expect(chef_run).to create_directory(baseDir)
      dir = chef_run.directory(baseDir)
      expect(dir).to be_owned_by(chef_run.node['wlp']['user'], chef_run.node['wlp']['group'])
    end

    it "create user config directory" do
      baseDir = chef_run.node['wlp']['user_dir']
      expect(chef_run).to create_directory(baseDir)
      dir = chef_run.directory(baseDir)
      expect(dir).to be_owned_by(chef_run.node['wlp']['user'], chef_run.node['wlp']['group'])
    end

    it "download runtime.jar" do
      expect(chef_run).to create_remote_file("/var/chef/cache/runtime.jar")
    end

    it "download extended.jar" do
      expect(chef_run).to create_remote_file("/var/chef/cache/extended.jar")
    end

    it "download extras.jar" do
      expect(chef_run).to create_remote_file("/var/chef/cache/extras.jar")
    end

    it  "install runtime.jar" do
      expect(chef_run).to execute_command("java -jar /var/chef/cache/runtime.jar --acceptLicense #{chef_run.node['wlp']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

    it  "install extended.jar" do
      expect(chef_run).to execute_command("java -jar /var/chef/cache/extended.jar --acceptLicense #{chef_run.node['wlp']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

    it  "install extras.jar" do
      expect(chef_run).to execute_command("java -jar /var/chef/cache/extras.jar --acceptLicense #{chef_run.node['wlp']['archive']['extras']['base_dir']}").with(:user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

  end

  ### Install using zip file
  context "zip::basic" do
    let (:chef_run) { 
      chef_run = ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '12.04')
      chef_run.node.set['wlp']['install_method'] = "zip"
      chef_run.node.set['wlp']['zip']['url'] = "http://example.com/wlp.zip"
      chef_run.converge 'wlp::default'
    }

    it "include zip_install" do
      expect(chef_run).to include_recipe('wlp::zip_install')
    end

    it "create group" do
      expect(chef_run).to create_group(chef_run.node['wlp']['group'])
    end

    it "create user" do
      expect(chef_run).to create_user(chef_run.node['wlp']['user'])
    end

    it "create base directory" do
      baseDir = chef_run.node['wlp']['base_dir']
      expect(chef_run).to create_directory(baseDir)
      dir = chef_run.directory(baseDir)
      expect(dir).to be_owned_by(chef_run.node['wlp']['user'], chef_run.node['wlp']['group'])
    end

    it "install unzip package" do
      expect(chef_run).to install_package("unzip")
    end

    it "download wlp.zip" do
      expect(chef_run).to create_remote_file("/var/chef/cache/wlp.zip")
    end

    it  "unzip wlp.zip" do
      expect(chef_run).to execute_command("unzip /var/chef/cache/wlp.zip").with(:cwd => chef_run.node['wlp']['base_dir'], :user => chef_run.node['wlp']['user'], :group => chef_run.node['wlp']['group'])
    end

  end
end


