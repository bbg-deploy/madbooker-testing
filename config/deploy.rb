# Include Unicorn Extentions
require 'capistrano-unicorn'

# Include Bundler Extensions
require 'bundler/capistrano'

# Capistrano Multistage support
require 'capistrano/ext/multistage'
set :default_stage, 'production'
set :stages, %w{production staging}

# Application Settings
set :repository,  "git@github.com:bbg-deploy/madbooker-testing.git"
set :branch, "master"
set :scm, :git
set :user, "deploy"

# Server Settings
role :web, "stage-app01.c46212.blueboxgrid.com"
role :app, "stage-app01.c46212.blueboxgrid.com"
role :db,  "stage-app01.c46212.blueboxgrid.com", :primary => true # This is where Rails migrations will run

# Capistrano Settings
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :use_sudo, false
set :keep_releases, 5

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

default_run_options[:pty] = true
default_environment["LANG"] = "en_us.UTF-8"

before "deploy:assets:precompile", "deploy:database_symlink"
after "deploy:restart", "unicorn:restart", "deploy:cleanup"

namespace :deploy do
  task :database_symlink, :except => { :no_release => true } do
    run "rm -f #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
