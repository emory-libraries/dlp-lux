# frozen_string_literal: true
unless Rails.env.production?
  require "rspec/core/rake_task"

  namespace :lux do
    # This rake task takes a prod-like environment as a variable and runs specs to ensure
    # that search and indexing of active data are running as expected.
    desc "PROD_LIKE_ENV=qa|test|arch|prod rake lux:relevancy"
    RSpec::Core::RakeTask.new(:relevancy) do |task|
      task.rspec_opts = "--tag relevancy:true"
    end
  end
end
