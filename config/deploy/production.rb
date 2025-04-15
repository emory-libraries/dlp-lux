# frozen_string_literal: true
require 'ec2_ipv4_retriever'
include Ec2Ipv4Retriever

set :stage, :PROD
set :honeybadger_env, "Lux-Prod"
server find_ip_by_ec2_name(ec2_name: 'digital.library.emory.edu') || ENV['PROD_SERVER_IP'], user: 'deploy', roles: %i[web app db]
