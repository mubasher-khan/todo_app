# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"
server '3.86.243.7', port: 22, roles: [:web, :app, :db], primary: true
set :application, "todo_app"
set :repo_url, "git@github.com:mubasher-khan/todo_app.git"
set :user, 'ubuntu' #server user
set :rvm_bin_path, "$HOME/bin"
set :rvm_ruby_version, '3.1.2'
set :use_sudo, false
set :rails_env, "production"
set :stage, :production
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(/Users/apple/Documents/ec2.pem) }
set :branch, "main"
set :scm, :git
set :pty, true
set :keep_releases, 5
set :connection_timeout, 5
set :linked_files, %w{config/database.yml}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

namespace :deploy do
  before :linked_files, :set_master_key do
    on roles(:app), in: :sequence, wait: 10 do
      unless test("[ -f #{shared_path}/config/master.key ]")
        upload! 'config/master.key', "#{shared_path}/config/master.key"
      end
    end
  end
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy: restart'
      invoke 'deploy'
    end
  end
  # set :linked_files, %w{config/database.yml}
  after :finishing, :compile_assets
  after :finishing, :cleanup
  after :finishing, :restart
end
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
