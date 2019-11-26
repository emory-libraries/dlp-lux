# frozen_string_literal: true
set :stage, :PROD
ec2_role %i[web app db],
         user: 'deploy',
         ssh_options: {
           keys: ENV['SSH_EC2_KEY_FILE'],
           forward_agent: true,
           verify_host_key: :never
         }
# server 'PRIVATE_IP_Address', user: 'deploy', roles: %i[web app db]
