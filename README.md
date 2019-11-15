# README

## Running locally

1. Clone the git repo: `git clone git@github.com:emory-libraries/dlp-lux.git`
1. Install the required gems: `bundle install`
1. Launch development instance of solr: `solr_wrapper`
1. Launch test instance of solr: `solr_wrapper --config config/solr_wrapper_test.yml`
1. Run the tests to ensure everything is working as expected: `rspec spec`
1. Launch a rails server: `rails server`
1. You should now be able to go to `http://localhost:3000` and see the application
