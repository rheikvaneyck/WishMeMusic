set :application, 'wishmemusic'
set :repo_url, 'git@github.com:rheikvaneyck/WishMeMusic.git'
# set :repo_url, 'git@example.com:me/my_repo.git'
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/wishmemusic'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/email.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Building gems'
  task :build_gems do
    on roles(:app) do |host|
      within release_path do
        execute :bundle, "install --deployment --without=development"
      end
    end
  end
      
  desc "Migrating database"
  task :migrations do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :rake, "db:migrate"
      end
    end 
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      within release_path do
        execute :rake, "web:stop"
        execute :rake, "web:run"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end