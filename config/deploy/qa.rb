# frozen_string_literal: true

server 'lux-qa.curationexperts.com', user: 'deploy', roles: %i[web app db]
set :default_env,
    PASSENGER_INSTANCE_REGISTRY_DIR: '/var/run/passenger-instreg'
