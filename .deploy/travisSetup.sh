#!/bin/bash
export RAILS_ENV=test
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed