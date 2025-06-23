# frozen_string_literal: true
# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

# Load environment variables
require 'dotenv'

Dotenv.load('.env.development')

set :application, "dlp-lux"
set :repo_url, "https://github.com/emory-libraries/dlp-lux.git"
set :deploy_to, '/opt/dlp-lux'
set :rails_env, 'production'
set :assets_prefix, "#{shared_path}/public/assets"
# set :migration_role, :app

SSHKit.config.command_map[:rake] = 'bundle exec rake'
set :branch, ENV['REVISION'] || ENV['BRANCH'] || ENV['BRANCH_NAME'] || 'master'

append :linked_dirs, "log", "public/assets", "tmp/pids", "tmp/cache", "tmp/sockets", "config/emory/groups"
append :linked_files, ".env.production", "config/secrets.yml", "config/reading_room_ips.yml"

set :default_env,
    PATH: '$PATH:/usr/local/rbenv/shims/:/usr/local/rbenv/shims/bin',
    LD_LIBRARY_PATH: '$LD_LIBRARY_PATH:/usr/local/rbenv/shims:/opt/rh/rh-ruby25/root/usr/local/lib64:/opt/rh/rh-ruby25/root/usr/lib64'

# Default value for local_user is ENV['USER']
set :local_user, -> { `git config user.name`.chomp }

# Restart passenger after deploy is finished
after :'deploy:finished', :'passenger:restart'

namespace :deploy do
  desc 'Ask user for CAB approval before deployment if stage is PROD'
  task :confirm_cab_approval do
    if fetch(:stage) == :PROD
      ask(:cab_acknowledged, 'Have you submitted and received CAB approval? (Yes/No): ')
      unless /^y(es)?$/i.match?(fetch(:cab_acknowledged))
        puts 'Please submit a CAB request and get it approved before proceeding with deployment.'
        exit
      end
    end
  end
end

before 'deploy:starting', 'deploy:confirm_cab_approval'

namespace :yarn do
  task :install do
    on roles :all do
      within release_path do
        execute :yarn, 'install'
      end
    end
  end
end

after :'deploy:assets:precompile', :'yarn:install'
