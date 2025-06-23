# frozen_string_literal: true
require 'ec2_ipv4_retriever'
include Ec2Ipv4Retriever

set :stage, :TEST
set :honeybadger_env, "Lux-Test"
server find_ip_by_ec2_name(ec2_name: 'digital-test.library.emory.edu') || ENV['TEST_SERVER_IP'], user: 'deploy', roles: %i[web app db]
