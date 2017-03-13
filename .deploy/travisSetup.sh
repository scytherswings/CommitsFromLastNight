#!/bin/bash
export RAILS_ENV=test
mkdir -p tmp/cache
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed