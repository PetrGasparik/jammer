# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'Jammer'
set :repo_url, 'https://github.com/gh2k/jammer.git'

require 'capistrano/setup'
require 'capistrano/deploy'

set :rvm_ruby_version, '2.0.0'

SSHKit.config.command_map[:rake]  = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'

set :whenever_roles, %w(db)

set :bundle_bins, %w{gem rake ruby}

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/jammer.sd.ai/rails'

# Default value for :log_level is :debug
set :log_level, :info

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    #on roles(:web), in: :groups, limit: 3, wait: 10 do
    #  within release_path do
    #    execute :rake, 'cache:clear'
    #  end
    #end
  end

  namespace :jammer do
    task :update do
      on roles(:db) do
        within release_path do
          execute :rake, 'jammer:update'
        end
      end
    end
  end

end
