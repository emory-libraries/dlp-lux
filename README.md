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
1. In order to be able to sign into the application locally, the environment variable `DATABASE_AUTH=true` must be set in your development environment.
  * You must create a user via the rails console:
  ```ruby
    bundle exec rails c
    u = User.new
    u.uid = "user"
    u.display_name = "User Name"
    u.email = "email@testdomain.com"
    u.password = "password"
    u.password_confirmation = "password"
    u.save
  ```
1. In order to see objects with a visibility of "Rose High View", your IP must match an address on the server in `config/reading_room_ips.yml`. See the existing file for the example setup.
1. Create and migrate the development database: `rails db:create db:migrate`
1. Create and migrate the test database: `RAILS_ENV=test rails db:create db:migrate`
1. Migrate the database: `rails db:migrate`
1. Install UV and any other JS dependencies: `yarn install`
1. Launch development instance of solr: `solr_wrapper`
1. Launch test instance of solr: `solr_wrapper --config config/solr_wrapper_test.yml`
1. Run the tests to ensure everything is working as expected: `rspec spec`
1. Launch a rails server: `rails server`
1. You should now be able to go to `http://localhost:3000` and see the application

## Running in production

1. The `IIIF_MANIFEST_URL` environment variable needs to be set. This URL is the base
URL for the Hyrax instance that serves the Work's IIIF manifest. An example:
`https://curate-qa.curationexperts.com/concern/curate_generic_works/`.
1. The `THUMBNAIL_URL` environment variable needs to be set. This URL is the base URL for the Hyrax instance that serves the Work's thumbnail images. An example: `https://curate-qa.curationexperts.com`

## HTTP Password protection in production mode
In order to prevent search engine crawling of the system before it's ready to launch, we use HTTP password protection. This is set via environment variables.
It is enabled by default. Set `HTTP_PASSWORD_PROTECT='false'` to disable this feature.
Set the login and password via environment variables `HTTP_USERNAME` and `HTTP_PASSWORD`

## Loading sample data

In order to have a local solr instance with data in it, run this rake task:
  ```
  rake lux:load_sample_data
  ```

This will populate your local development instance of solr with a snapshot of curate data. The catalog_controller currently limits solr searches to items where the visibility is not restricted, or the visibility is discovery.

## Deploying to Emory servers

1. To deploy, first connect to the Emory VPN.
1. run `tki` and receive your 12-hour AWS credentials.
1. run the following command:
```bash
AWS_PROFILE=tki-aws-account-70-rhedcloud/RHEDcloudAdministratorRole BRANCH=<tag> bundle exec cap <env> deploy
```
where `<tag>` is either a version, like v0.4.32, or a branch, like master and
where `<env>` is one of production, test, or arch.

## Running test suite
* Run `rspec spec` to run the default test suite
* To run only specific tests, include
  * the directory, e.g. `rspec spec/system`,
  * or the path to the test, e.g. `rspec spec/system/search_catalog_spec.rb`,
  * or, if you want to be super specific, you can even add the line number the spec starts on at the beginning, e.g. `rspec spec/system/search_catalog_spec.rb:178`
  * Can also run with tags, e.g. `rspec spec --tag relevancy:true`

## Run relevancy tests
* Run `PROD_LIKE_ENV=qa|test|arch|prod rake lux:relevancy`
* This rake task takes a prod-like environment as a variable and runs specs to ensure that search and indexing of active data are running as expected.
