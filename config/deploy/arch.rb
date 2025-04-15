# frozen_string_literal: true
require 'ec2_ipv4_retriever'
include Ec2Ipv4Retriever

set :stage, :ARCH
set :honeybadger_env, "Lux-Arch"
server find_ip_by_ec2_name(ec2_name: 'digital-arch.library.emory.edu') || ENV['ARCH_SERVER_IP'], user: 'deploy', roles: %i[web app db]
