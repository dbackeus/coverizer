set :application, "coverizer"

set :host, "skistar.eframe.se"

set :deploy_to, "/home/deploy/apps/#{application}"

set :use_sudo, false

ssh_options[:port] = 8888

default_run_options[:pty] = true

set :repository, "git://github.com/druiden/coverizer.git"
set :scm, "git"
set :user, "deploy"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

role :production, host

# ===========================================================================
# Database
# ===========================================================================  

namespace :db do
	
	task :migrate do
		run "cd #{current_path} && rake db:migrate"
	end
	
end

# ===========================================================================
# Mongrel
# ===========================================================================  

namespace :mongrel do
  
  def mongrel_cluster(command)
    "cd #{current_path} && " +
    "mongrel_rails cluster::#{command} -C #{current_path}/config/mongrel_cluster.yml"
  end

  %w(restart stop start).each do |command|
    task command.to_sym do
      run mongrel_cluster(command)
    end
  end
  
end

# ===========================================================================
# Deployment hooks
# ===========================================================================

namespace :deploy do
	
	desc "Restart mongrel cluster"
	task :restart do
  	mongrel.restart
	end
	
  desc "Copy or link in server specific configuration files"
  task :setup_config do
    run <<-CMD
    cp #{release_path}/config/database.yml.example #{release_path}/config/database.yml
    CMD
  end

  desc "Run pre-symlink tasks" 
  task :before_symlink do
    setup_config
  end
  
  desc "Clear out old code trees. Only keep 5 latest releases around"
  task :after_deploy do
    #db.migrate
    cleanup
  end
  
end