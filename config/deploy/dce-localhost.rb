# frozen_string_literal: true

server '127.0.0.1', user: 'deploy', roles: %i[web app db]
set :default_env,
    PASSENGER_INSTANCE_REGISTRY_DIR: '/var/run/passenger-instreg'
