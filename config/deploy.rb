# Include Unicorn Extentions
require 'capistrano-unicorn'

# Include Bundler Extensions
require 'bundler/capistrano'

# Application Settings
set :application, "madbooker"
set :repository,  "git@github.com:bbg-deploy/madbooker.git"
set :branch, "bbg-deploy"
set :scm, :git
set :deploy_to, "/srv/apps/#{application}"
set :user, "deploy"

# Server Settings
role :web, "app01.c46212.blueboxgrid.com"
role :app, "app01.c46212.blueboxgrid.com"
role :db,  "app01.c46212.blueboxgrid.com", :primary => true # This is where Rails migrations will run

# Capistrano Settings
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :use_sudo, false
set :keep_releases, 5

default_run_options[:pty] = true
default_environment["LANG"] = "en_us.UTF-8"

after "deploy:update_code", "deploy:database_symlink"
after "deploy:restart", "unicorn:duplicate", "deploy:cleanup"

namespace :deploy do
  task :database_symlink, :except => { :no_release => true } do
    run "rm -f #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
