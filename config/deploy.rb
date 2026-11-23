# frozen_string_literal: true
# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

# Load environment variables
require 'dotenv'

Dotenv.load('.env.development')

# Clear out the removed CLI flags
set :bundle_flags, "--quiet"
set :bundle_path, nil
set :bundle_without, nil

set :application, "dlp-lux"
set :repo_url, "https://github.com/emory-libraries/dlp-lux.git"
set :deploy_to, '/opt/dlp-lux'
set :rbenv_type, :system
set :rbenv_ruby, '3.3.14'
set :rails_env, 'production'
set :assets_prefix, "#{shared_path}/public/assets"
set :branch, ENV['REVISION'] || ENV['BRANCH'] || ENV['BRANCH_NAME'] || 'main'

append :linked_dirs, "log", "public/assets", "tmp/pids", "tmp/cache", "tmp/sockets", "config/emory/groups", "node_modules"
append :linked_files, ".env.production", "config/secrets.yml", "config/reading_room_ips.yml"
append :rbenv_map_bins, "passenger", "passenger-config", "passenger-status"

set :default_env,
    PATH: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH",
    LD_LIBRARY_PATH: "$LD_LIBRARY_PATH:/usr/lib64"

# Default value for local_user is ENV['USER']
set :local_user, -> { `git config user.name`.chomp }

namespace :deploy do
  desc "Ask user for CAB approval before deployment if stage is PROD"
  task :confirm_cab_approval do
    if fetch(:stage) == :PROD
      ask(:cab_acknowledged, "Have you submitted and received CAB approval? (Yes/No): ")
      abort "Please submit a CAB request and get it approved before proceeding with deployment." unless /^y(es)?$/i.match?(fetch(:cab_acknowledged).to_s)
    end
  end

  desc "Restart Apache httpd"
  task :apache do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :httpd
    end
  end
end

namespace :yarn do
  task :install do
    on roles(:app) do
      within release_path do
        execute :yarn, "install", "--frozen-lockfile", "--production"
      end
    end
  end
end

namespace :bundler do
  task :configure_bundler4 do
    on roles fetch(:bundle_roles, :all) do
      within release_path do
        with fetch(:bundle_env_variables, {}) do
          execute :bundle, "config set --local deployment 'true'"
          execute :bundle, "config set --local path '#{shared_path.join('bundle')}'"
          execute :bundle, "config set --local without 'development test'"
        end
      end
    end
  end
end

before "deploy:starting", "deploy:confirm_cab_approval"
before "deploy:assets:precompile", "yarn:install"
before "bundler:install", "bundler:configure_bundler4"
after "deploy:finishing", "deploy:apache"
