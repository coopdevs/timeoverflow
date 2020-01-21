# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'timeoverflow'
set :repo_url, 'git@github.com:coopdevs/timeoverflow.git'

set :rbenv_type, :user

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(
  # "config/database.yml",
  # "config/secrets.yml",
  # ".env",
)

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system'
)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :unicorn do
  desc 'reload Unicorn'
  task :reload do
    on roles(:app) do
      execute "sudo systemctl reload timeoverflow"
    end
  end
end

namespace :sidekiq do
  desc 'reload Sidekiq'
  task :restart do
    on roles(:app) do
      execute "sudo systemctl restart sidekiq"
    end
  end
end

task "deploy:db:load" do
  on primary :db do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "db:schema:load"
      end
    end
  end
end

before "deploy:migrate", "deploy:db:load" if ENV["COLD"]

after "deploy:finishing", "unicorn:reload"
after "deploy:finishing", "sidekiq:restart"
