[![CircleCI](https://circleci.com/gh/emory-libraries/dlp-lux.svg?style=svg)](https://circleci.com/gh/emory-libraries/dlp-lux)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a0d9d34d60d7f3ffe2c2/test_coverage)](https://codeclimate.com/github/emory-libraries/dlp-lux/test_coverage)

# README

Discovery application for Emory's Cor repository.

* Ruby version 2.7.5, Rails version 5.1

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
Set `HTTP_PASSWORD_PROTECT='true'` to enable this feature.
Set `HTTP_PASSWORD_PROTECT='false'` to disable this feature.
Set the login and password via environment variables `HTTP_USERNAME` and `HTTP_PASSWORD`

# Deployment

1. Connect to `vpn.emory.edu`
2. Pull the latest version of `main`
3. Stub AWS' environment variables for `Emory Account 70` within the same terminal window. These can be found in the page loaded after logging into [Emory's AWS](https://aws.emory.edu). Directions below:
  a. After logging in, the page should be the `AWS access portal`. A table of multiple accounts should be presesnt (typically three). Expand the `Emory Account 70` option.
  b. Clicking on `Access keys` will open a modal with multiple credential options. Option 1 (`Set AWS environment variables`) is necessary for successful deployment.
  c. Copy the variables in Option 1, paste them into the terminal window that the deployment script will be processed, and press enter.
5. To deploy, run `BRANCH={BRANCH_NAME_OR_TAG} bundle exec cap {ENVIRONMENT} deploy`. To deploy main to the arch environment, for instance, you run `BRANCH=main bundle exec cap arch deploy`.

## Deployment Troubleshooting

If errors occur when running the deployment script, there could be a couple of factors causing them:
- Ensure you are authorized to access the server you are deploying to. You can verify your access by trying to ssh into the server e.g. `ssh deploy@SERVER_IP_ADDRESS`.
- The server IP lookup processing may not be working. In this case, stub the backup environment variables for the desired server in the local `.env.development` file. The list of backup environment variables are below:

```
ARCH_SERVER_IP=
TEST_SERVER_IP=
PROD_SERVER_IP=
```

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

## Run blacklight performance tests
* Before your announced testing time window:
  *   Install Apache Jmeter https://jmeter.apache.org/
  *   From the project jmeter directory, run jmeter in GUI mode (`jmeter` with no command-line arguments on unix-like systems).
    *   Open `jmeter/blacklight.jmx` from the file menu.
    *   In the `User Defined Variables` panel, set the values of `threads` and `loops` to 1 for initial smoke-test run.
    *   Check that the server name in the `HTTP Request Defaults` matches the server you want to run against (`digital.library.emory.edu` for production)
    *   Add a username and password to the `HTTP Authorization Manager` if running against a system with HTTP basic auth in place.
    *   "Save test plan as" and a temporary filename (blacklight-tmp.jmx for instance)
  *   Run jmeter from the command line, replacing "trialname" with an unused filename: `jmeter -n -t blacklight-tmp.jmx -l trialname.jtl -e -o report-trialname`
  *   Look for "Err: 0 (0.00%)" in the jmeter output; if there were errors, troubleshoot those before continuing to load testing.
* During your announced testing time window:
  *   Re-open your temporary copy of the test plan in the jmeter GUI
  *   In the `User Defined Variables` panel, set the value of `threads` to the initial number of simultaneous users you want to simulate, and the value of `loops` to the number of times you want each simulated user to run through the suite of pages.  Save your changes.
  *   Run jmeter from the command line, replacing "trialname" with a new unused filename: `jmeter -n -t blacklight-tmp.jmx -l trialname.jtl -e -o report-trialname`
  * Repeat the previous two steps for each level of load to be simulated.

## Run jmeter smoke test
* Install and run Apache Jmeter in GUI mode as above.
* Open `jmeter/smoke-test.jmx` from the file menu.
* Add a username and password to the `HTTP Authorization Manager` if running against a system with HTTP basic auth in place.
* Hit the green forward arrow to start the tests running.
* View the results in "View Results Tree" (green with a checkmark for successes, red with an x for failures)
