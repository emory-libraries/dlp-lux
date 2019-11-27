[![CircleCI](https://circleci.com/gh/emory-libraries/dlp-lux.svg?style=svg)](https://circleci.com/gh/emory-libraries/dlp-lux)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a0d9d34d60d7f3ffe2c2/test_coverage)](https://codeclimate.com/github/emory-libraries/dlp-lux/test_coverage)

# README

Discovery application for Emory's Cor repository.

Things you may want to cover:

* Ruby version 2.5.3, Rails version 5.1

* Blacklight 7

## Running locally

1. Clone the git repo: `git clone git@github.com:emory-libraries/dlp-lux.git`
1. `cd ./dlp-lux`
1. Install the required gems: `bundle install`
1. Migrate the database: `rails db:migrate`
1. Launch development instance of solr: `solr_wrapper`
1. Launch test instance of solr: `solr_wrapper --config config/solr_wrapper_test.yml`
1. Run the tests to ensure everything is working as expected: `rspec spec`
1. Launch a rails server: `rails server`
1. You should now be able to go to `http://localhost:3000` and see the application
