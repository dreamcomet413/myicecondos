server "45.58.37.92", :web, :app, :db, primary: true

set :rails_env, "staging"
set :unicorn_user, "#{user}"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
set :unicorn_config, "#{shared_path}/config/unicorn_staging.rb"
set :unicorn_log, "#{shared_path}/log/unicorn.log"
set :unicorn_workers, 1
