require 'bundler/capistrano'
require "rvm/capistrano"                               # Load RVM's capistrano plugin.

set :rvm_type, :user
set :rvm_ruby_string, '1.9.3@restest'                  # Or whatever env you want it to run in.

default_run_options[:pty] = true

set :application, "ResTest"
set :repository,  "git@github.com:ThreeWiseMen/ResTest.git"

set :deploy_to, "~/#{application}"

set :scm, :git

set :deploy_via, "remote_cache"

set :user, "restest"
set :use_sudo, false

set :branch, 'master'

role :app, "restest.threewisemen.ca"
role :web, "restest.threewisemen.ca"
role :db,  "restest.threewisemen.ca", :primary => true
set :rails_env, 'production'

namespace :deploy do
  task :start do
    run "cd #{current_path} && bundle exec unicorn --config-file #{current_path}/config/unicorn.#{rails_env}.conf.rb --daemonize --env #{rails_env}"
  end
  task :stop do
    run "if [ -e #{deploy_to}/shared/pids/unicorn.pid ]; then cat #{deploy_to}/shared/pids/unicorn.pid* | xargs kill; fi"
  end
  task :restart do
    run "if [ -e #{deploy_to}/shared/pids/unicorn.pid ]; then cat #{deploy_to}/shared/pids/unicorn.pid* | xargs kill -s USR2; fi"
  end

  task :full do
    update
    migrate
    restart
    cleanup
  end
end

require './config/boot'
# require 'airbrake/capistrano'
