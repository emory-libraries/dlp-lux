[![CircleCI](https://circleci.com/gh/emory-libraries/dlp-lux.svg?style=svg)](https://circleci.com/gh/emory-libraries/dlp-lux)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a0d9d34d60d7f3ffe2c2/test_coverage)](https://codeclimate.com/github/emory-libraries/dlp-lux/test_coverage)

# README

Discovery application for Emory's Cor repository.

* Ruby version 2.5.3, Rails version 5.1

* Blacklight 7

* MySQL 5.7.22

## Running locally

1. Install and start up MySQL 5.7
1. Clone the git repo: `git clone git@github.com:emory-libraries/dlp-lux.git`
1. `cd ./dlp-lux`
1. Install the required gems: `bundle install`
1. Configure the MySQL development and test databases. This is accomplished by setting the environment variables that `database.yml` expects. In the root directory of the application, create a `.env` file and add the line `DATABASE_USERNAME=root`. (By default, MySQL has the username `root` with no password.) Also create a `.env.development` file and a `.env.test` file and add the lines `DATABASE_NAME=dlp-lux_development` and `DATABASE_NAME=dlp-lux_test`, respectively.
1. Create and migrate the development database: `rails db:create db:migrate`
1. Create and migrate the test database: `RAILS_ENV=test rails db:create db:migrate`
1. Launch development instance of solr: `solr_wrapper`
1. Launch test instance of solr: `solr_wrapper --config config/solr_wrapper_test.yml`
1. Run the tests to ensure everything is working as expected: `rspec spec`
1. Launch a rails server: `rails server`
1. You should now be able to go to `http://localhost:3000` and see the application
