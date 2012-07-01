#this part goes in the deploy.rb file inside the config in your rails app

require 'bundler/capistrano'

set :application, "sucurilabs.net"

set :domain, "sucurilabs.net"
set :environment, "production"
set :branch, "master"
set :deploy_to, "/var/www/#{application}"

role :app, domain
role :web, domain
role :db, domain, :primary => true

default_run_options[:pty] = true

default_run_options[:shell] = 'bash'

default_environment["RAILS_ENV"] = 'production'

set :repository, "git@github.com:sucurilabs/sucurilabs-website.git"
set :deploy_via, :remote_cache

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :scm_verbose, true
set :use_sudo, false
set :ssh_options, :forward_agent => true

set :user, "deployerbot"
set :keep_releases, 5

set :default_environment, {
    'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p194@sucurilabs-website/gems/bin:/usr/local/rvm/bin:$PATH",
    'RUBY_VERSION' => 'ruby 1.9.3',
    'GEM_HOME' => '/usr/local/rvm/gems/ruby-1.9.3-p194@sucurilabs-website/gems',
    'GEM_PATH' => '/usr/local/rvm/gems/ruby-1.9.3-p194@sucurilabs-website/gems:/usr/local/rvm/gems/ruby-1.9.3-p194@global/gems',
    'BUNDLE_PATH' => '/usr/local/rvm/gems/ruby-1.9.3-p194@sucurilabs-website/gems' # If using bundler.
}
set :bundle_gemfile,      "Gemfile"
  set :bundle_dir,          fetch(:shared_path)+"/bundle"
  set :bundle_flags,        "--deployment --quiet"
  set :bundle_without,      [:development, :test]


namespace :deploy do
  desc "restarting"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "symlink vendor to shared vendor"
  task :symlink_vendor_to_shared_vendor do
    run "ln -s #{current_path}/../shared/vendor #{current_path}/vendor"
  end

  desc "trust rvmrc"
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
  desc "Install bundler"
  task :bundle_install do
    begin
      run "bundle install"
    rescue
      gem_install_bundler
    end
  end

  desc "installs Bundler if it is not already installed"
  task :gem_install_bundler, :roles => :app do
    run "cd #{deploy_to}/current; gem install bundler && bundle install"
  end
end

task :ruby_version, :roles => :app do
  run "ruby -v"
  run "source /etc/profile; rvm list"
  run "rvm list"
end
after 'deploy:symlink', 'deploy:symlink_vendor_to_shared_vendor', 'deploy:trust_rvmrc'
