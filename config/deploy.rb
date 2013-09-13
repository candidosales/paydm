# Automatically precompile assets
load "deploy/assets"
require "bundler/capistrano"
# ==============================================================
# SET's
# ==============================================================
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :domain, "54.232.195.152"
set :application, "paydm"
set :repository, "git@github.com:candidosales/#{application}.git"

set :user, "ubuntu"
set :runner, "ubuntu"
set :group, "ubuntu"
ssh_options[:keys] =[File.join(ENV["HOME"], ".ec2", "gce-paydm.pem")]
set :use_sudo, false

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :current, "#{deploy_to}/current"
set :keep_releases, 1


# ==============================================================
# ROLE's
# ==============================================================

server domain, :app, :web, :db, :primary => true

namespace :deploy do
  task :start do
    run "cd #{current} && RAILS_ENV=production && GEM_HOME=/opt/local/ruby/gems && bundle exec unicorn_rails -c #{deploy_to}/config/unicorn.rb -D"
  end

  task :stop do
    run "if [ -f #{deploy_to}/shared/pids/unicorn.pid ]; then kill `cat #{deploy_to}/shared/pids/unicorn.pid`; fi"
  end

  task :restart do
    stop
    start
  end
end

namespace :ubuntu do

	desc "Update ubuntu"
	task :update_upgrade, :roles => :app do
		run "sudo apt-get -y update"
		run "sudo apt-get -y upgrade"
		run "sudo apt-get -y dist-upgrade"
		run "sudo apt-get -y autoremove"
		run "sudo reboot"
	end

	desc "Setup Environment"
	task :setup_env, :roles => :app do
		install_dev_tools
		install_git
		install_imagemagick
	end

	desc "Install Development Tools"
	task :install_dev_tools, :roles => :app do
		run "sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion nodejs -y"
	end

	desc "Install Git"
	task :install_git, :roles => :app do
		run "sudo apt-get install git-core git-svn git gitk ssh libssh-dev -y"
	end

	desc "Install ImageMagick"
	task :install_imagemagick, :roles => :app do
		run "sudo apt-get install imagemagick libmagickwand-dev -y"
	end

	desc "Configurações do Path"
	task :config_path, :roles => :app do
		run "sudo sh -c 'echo export PATH=/opt/local/bin:/opt/local/sbin:/opt/local/ruby/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' >> /etc/profile"
		#sudo sh -c "echo 'export RAILS_ENV=production' >> /etc/profile"
		#sudo sh -c "echo 'export GEM_HOME=/opt/local/ruby/gems' >> /etc/profile"
		#sudo sh -c "echo 'export LC_ALL=en_US.UTF-8' >> /etc/profile"
		sudo "echo $PATH"

		#run 'sudo echo "export PATH=/opt/local/bin:/opt/local/sbin:/opt/local/ruby/gems/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /etc/environment'
		#run 'sudo echo "RAILS_ENV=production" >> /etc/environment'
		#run 'sudo echo "GEM_HOME=/opt/local/ruby/gems" >> /etc/environment'
		#run 'sudo echo "LC_ALL=en_US.UTF-8" >> /etc/environment'
	end

	desc "Install Ruby Stable"
	task :install_ruby, :roles => :app do
		run "sudo apt-get install libyaml-dev libssl-dev libreadline-dev libxml2-dev libxslt1-dev libffi-dev -y"
		run "sudo mkdir -p /opt/local/src"
		run "cd /opt/local/src && sudo wget http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.bz2 && sudo tar xvf ruby-2.0.0-p247.tar.bz2"
		run "cd /opt/local/src/ruby-2.0.0-p247 && sudo ./configure --prefix=/opt/local/ruby/2.0.0 && sudo make && sudo make install"
	end

	#wbotelhos.com/2012/10/23/ruby-unicorn-e-nginx-na-amazon-ec2
	desc "Configure simbolin links ruby" 
	task :simbol_link, :roles => :app do
		run "sudo ln -s /opt/local/ruby/2.0.0 /opt/local/ruby/current"
		run "sudo ln -s /opt/local/src/ruby-2.0.0-p247 /opt/local/ruby/current"

		run "sudo mkdir -p /opt/local/bin"
		run "sudo mkdir -p /opt/local/sbin"

		run "sudo ln -s /opt/local/ruby/current/bin/erb    /opt/local/bin/erb"
		run "sudo ln -s /opt/local/ruby/current/bin/gem    /opt/local/bin/gem"
		run "sudo ln -s /opt/local/ruby/current/bin/irb    /opt/local/bin/irb"
		run "sudo ln -s /opt/local/ruby/current/bin/rake   /opt/local/bin/rake"
		run "sudo ln -s /opt/local/ruby/current/bin/rdoc   /opt/local/bin/rdoc"
		run "sudo ln -s /opt/local/ruby/current/bin/ri     /opt/local/bin/ri"
		run "sudo ln -s /opt/local/ruby/current/bin/ruby   /opt/local/bin/ruby"
		run "sudo ln -s /opt/local/ruby/current/bin/testrb /opt/local/bin/testrb"

		run "sudo ln -s /opt/local/ruby/current/sbin/erb     /opt/local/sbin/erb"
		run "sudo ln -s /opt/local/ruby/current/sbin/gem     /opt/local/sbin/gem"
		run "sudo ln -s /opt/local/ruby/current/sbin/irb     /opt/local/sbin/irb"
		run "sudo ln -s /opt/local/ruby/current/sbin/rake    /opt/local/sbin/rake"
		run "sudo ln -s /opt/local/ruby/current/sbin/rdoc    /opt/local/sbin/rdoc"
		run "sudo ln -s /opt/local/ruby/current/sbin/ri      /opt/local/sbin/ri"
		run "sudo ln -s /opt/local/ruby/current/sbin/ruby    /opt/local/sbin/ruby"
		run "sudo ln -s /opt/local/ruby/current/sbin/testrb  /opt/local/sbin/testrb"

		run "ruby -v"
	end

	desc "Atualizar Gem"
	task :update_gem, :roles => :app do
		run "sudo gem update --system"
	end

	desc "Install bundle"
	task :install_bundler, :roles => :app do
		run "sudo gem install bundler"
	end

	desc "Mysql"
	task :mysql, :roles => :app do
		run "sudo apt-get install mysql-client mysql-server libmysqlclient-dev -y"
	end

	desc "PostGres"
	task :postgres, :roles => :app do
		run "sudo apt-get install postgresql postgresql-contrib libpq-dev -y"
	end
end

namespace :nginx do

	task :setup_env, :roles => :app do
		install
		simbol_link
	end

	desc "Install Nginx"
	task :install, :roles => :app do
		run "sudo apt-get install libpcre3-dev libssl-dev -y"
		run "sudo wget http://nginx.org/download/nginx-1.5.4.tar.gz"
		run "sudo tar xvf nginx-1.5.4.tar.gz"
		run "cd nginx-1.5.4 && sudo ./configure --prefix=/opt/local/nginx/1.5.4 --with-http_ssl_module --with-http_realip_module --with-http_gzip_static_module --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/body --http-proxy-temp-path=/var/lib/nginx/proxy --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --with-debug --with-ipv6"
		run "cd nginx-1.5.4 && sudo make && sudo make install"
	end

	desc "Configure simbolin links nginx"
	task :simbol_link, :roles => :app do
		run "sudo ln -s /opt/local/nginx/1.5.4 /opt/local/nginx/current"
		run "sudo ln -s /opt/local/nginx/current/bin/nginx /opt/local/bin/nginx"
		run "sudo ln -s /opt/local/nginx/current/sbin/nginx /opt/local/sbin/nginx"
		run "nginx -v"
	end

	task :config_folder, :roles => :app do
		run "sudo mkdir /var/www"
		run "sudo chown ubuntu:ubuntu /var/www"
		run "sudo chmod 774 /var/www"
		run "sudo mkdir -p /var/lib/nginx/body"
		run "sudo mkdir -p /var/lib/nginx/proxy"
		run "sudo mkdir -p /var/lib/nginx/fastcgi"
		run "sudo chown -R ubuntu:ubuntu /var/lib/nginx"
		run "sudo mkdir -p /var/log/nginx/"
		run "sudo chown ubuntu:ubuntu /var/log/nginx"
		run "sudo mkdir /etc/nginx/ssl"
		run "sudo mkdir /etc/nginx/sites-enabled"
	end

	%w[start stop restart].each do |command|
		desc "#{command.capitalize} Nginx server."
		task command do
			run "sudo #{command} nginx"
		end
	end

	task :permission, :roles => :app do
		run "sudo chown ubuntu:ubuntu /var/log/nginx/error.log"
		run "sudo chown ubuntu:ubuntu /var/run/nginx.pid"
		run "sudo chown ubuntu:ubuntu /var/log/nginx/access.log"
		run "sudo chown ubuntu:ubuntu /etc/nginx/nginx.conf"
	end
end

after "deploy", "deploy:cleanup" 