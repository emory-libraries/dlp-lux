# frozen_string_literal: true
# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "dlp-lux"
set :repo_url, "https://github.com/emory-libraries/dlp-lux.git"
set :deploy_to, '/opt/dlp-lux'
set :rails_env, 'production'
set :assets_prefix, "#{shared_path}/public/assets"
# set :migration_role, :app
# use whenever to manage cron jobs
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

SSHKit.config.command_map[:rake] = 'bundle exec rake'
set :branch, ENV['REVISION'] || ENV['BRANCH'] || ENV['BRANCH_NAME'] || 'master'

append :linked_dirs, "log", "public/assets", "tmp/pids", "tmp/cache", "tmp/sockets", "config/emory/groups"
append :linked_files, ".env.production", "config/secrets.yml", "config/reading_room_ips.yml"

set :default_env,
    PATH: '$PATH:/opt/rh/rh-ruby25/root/usr/local/bin:/opt/rh/rh-ruby25/root/usr/bin',
    LD_LIBRARY_PATH: '$LD_LIBRARY_PATH:/opt/rh/rh-ruby25/root/usr/local/lib64:/opt/rh/rh-ruby25/root/usr/lib64',
    PASSENGER_INSTANCE_REGISTRY_DIR: '/var/run'

set :ec2_profile, ENV['AWS_PROFILE'] || ENV['AWS_DEFAULT_PROFILE']
set :ec2_region, %w[us-east-1]
set :ec2_contact_point, :private_ip
set :ec2_project_tag, 'EmoryApplicationName'
set :ec2_stages_tag, 'EmoryEnvironment'

# Default value for local_user is ENV['USER']
set :local_user, -> { `git config user.name`.chomp }

# Restart passenger after deploy is finished
after :'deploy:finished', :'passenger:restart'

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
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
