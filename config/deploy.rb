# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'paydm'
set :repo_url, 'git@github.com:candidosales/paydm.git'
set :scm, :git
set :keep_releases, 5
# set :deploy_via, :remote_cache

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{tmp/pids}

set :unicorn_config_path, "config/unicorn.rb"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
  after :finishing, :cleanup

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #  execute :rake, 'cache:clear'
      # end
    end
  end

  # task :fix_absent_manifest_bug do
  #   on roles(:web) do
  #     within release_path do  execute :touch,
  #       release_path.join('public', fetch(:assets_prefix), 'manifest-fix.temp')
  #     end
  #  end
  # end
  #
  # after :updating, 'deploy:fix_absent_manifest_bug'

end
