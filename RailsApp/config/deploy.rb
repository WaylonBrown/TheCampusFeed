# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'cfeed'
set :repo_url, 'git@github.com:AggieDev/TheCampusFeed.git'
set :repo_tree, 'RailsApp/'
set :rvm_ruby_version, '2.0.0-p598'

set :deploy_via, :remote_cache

#set :rbenv_ruby, '2.0.0'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

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
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

before 'deploy:assets:precompile', :symlink_config_files

desc "Link shared files"
task :symlink_config_files do
  on roles(:web) do
    symlinks = {
      "#{shared_path}/config/local_env.yml" => "#{release_path}/config/local_env.yml"
    }
    execute symlinks.map{|from, to| "ln -nfs #{from} #{to}"}.join(" && ")
  end
end


namespace :deploy do

  desc "reload the database with seed data"
  task :seed do
    on roles(:web) do
      within release_path do
        execute :rake, "db:seed RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

  after :publishing, :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute 'service', 'thin restart'
        execute 'service', 'sidekiq restart'
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        #execute :rake, 'cache:clear'
        #execute 'bundle exec rails s -e production &'
        #execute 'RAILS_ENV=production bundle exec sidekiq &'
      end
    end
  end

end
