#!/bin/bash
export RAILS_ENV=test
mkdir -p tmp/cache
bundle exec rake db:setup
