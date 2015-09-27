paydm
=====

Sistema de pagamento DeMolay (PI)


# Deploy in VPS
## Spin up an instance

Your choice: AWS, Digital Ocean, Linode, etc.

I’m using Ubuntu 14.04.

## Get SSH access

This varies by provider, but I recommend adding an authorized key and logging in with that, rather than a password.

Digital Ocean lets you select from pre-uploaded keys to install, making the process straightforward.

## Install prerequisites

root@remote $ apt-get update
root@remote $ apt-get install curl git libpq-dev git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev nodejs nginx

## Create deploy user
root@remote $ adduser deploy
root@remote $ passwd -l deploy
root@remote $ sudo usermod -a -G sudo deploy
root@remote $ passwd deploy

## Instal postgresql
root@remote $ apt-get install postgresql-client

## Install mysql

root@remote $  sudo apt-get install mysql-client mysql-common mysql-server
root@remote $ apt-get install -y libmysqlclient-dev

Saia e entre de novo no como user deploy
ssh deploy@00.00.0.000


## Install rbenv (and ruby-build)

deploy@remote $ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
deploy@remote $ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
deploy@remote $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
deploy@remote $ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile  

Restart your shell.
deploy@remote $ exec bash -l

## Install a ruby:

deploy@remote $ rbenv install 2.2.0
deploy@remote $ rbenv global 2.2.0

## Problem install : 2.2.0 Build fails on Ubuntu 14.04.1

 deploy@remote $ sudo apt-get install libffi-dev

 Restart install ruby

## Set up app server-side

deploy@remote $ mkdir ~/apps
deploy@remote $ mkdir ~/apps/<app-name>
deploy@remote $ mkdir ~/apps/<app-name>/shared

### Copy database.yml
user@local $ scp config/database.yml deploy@server-ip:~/apps/<app-name>/shared/config/database.yml

### Create log unicorn e .env
deploy@remote $ mkdir ~/apps/<app-name>/shared
deploy@remote $ touch ~/apps/<app-name>/shared/log/unicorn.stderr.log
deploy@remote $ touch ~/apps/<app-name>/shared/.env


deploy@remote $ gem install bundler

### Create nginx config for your site

deploy@remote $ vim /etc/nginx/sites-enabled/default

copy and paste

upstream app_server {
  server unix:/tmp/unicorn.<app-name>.socket fail_timeout=0;
}

server {
  listen 80;
  server_name <app-domain>;

  root /home/deploy/apps/<app-name>/current/public;

  location / {
    proxy_set_header  X-Real-IP  $remote_addr;
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;

    if (-f $request_filename/index.html) {
      rewrite (.*) $1/index.html break;
    }

    if (-f $request_filename.html) {
      rewrite (.*) $1.html break;
    }

    if (!-f $request_filename) {
      proxy_pass http://app_server;
      break;
    }
  }
}

## Deployment config
Gemfile:

group :development do
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rails-collection'
  gem 'capistrano3-unicorn'
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
end

Capfile:
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/rails'
require 'capistrano3/unicorn'
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

deploy.rb:

# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'app-name'
set :repo_url, 'git@wherever.git'

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{tmp/pids}

set :unicorn_config_path, "config/unicorn.rb"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.1'
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

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

config/deploy/production.rb:
set :stage, :production

set :deploy_to, '~/apps/app-name'

set :branch, 'master'

set :rails_env, 'production'

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w{deploy@app-host}
role :web, %w{deploy@app-host}
role :db,  %w{deploy@app-host}


config/unicorn.rb

# Set environment to development unless something else is specified
env = ENV["RAILS_ENV"] || "development"


# Production specific settings
if env == "production"
  app_dir = "app-name"
  worker_processes 4
end

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/unicorn.#{app_dir}.socket", :backlog => 64

# Preload our app for more speed
preload_app true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory "/home/deploy/apps/#{app_dir}/current"

# feel free to point this anywhere accessible on the filesystem
user 'deploy', 'deploy'
shared_path = "/home/deploy/apps/#{app_dir}/shared"

stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

pid "#{shared_path}/tmp/pids/unicorn.pid"


before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{shared_path}/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

## Deploy

user@local $ cap production deploy

##

/var/log/nginx/access.log
/var/log/nginx/error.log

>uri=URI('https://ws.sandbox.pagseguro.uol.com.br/v2/sessions')
>res=Net::HTTP.post_form(uri,email: PagSeguro.email,token: PagSeguro.token)



http://theflyingdeveloper.com/server-setup-ubuntu-nginx-unicorn-capistrano-postgres/
https://help.ubuntu.com/community/PostgreSQL

sudo usermod -a -G sudo deploy



© 2014-2015, One Month, Inc. | Blog | Feedback | About GoRails

## Access server
ssh deploy@45.79.0.161 / root

## Problemas deploy

1. Problema de precompile assets
Remover do Capfile todos os capistrano/rails e deixa somente capistrano/migrations. Com isso o deploy pula o precompile

2. Problema em não reiniciar o unicorn.
Identificar os processos ( ps aux | grep unicorn ) e depois matá-los ( kill )

## Password Deploy image Linode / deploy user :
Rootpaydm
