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

#set :scm_passphrase, "p00p" #This is your custom users password

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
