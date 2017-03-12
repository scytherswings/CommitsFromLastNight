#!/bin/bash
touch "config.yml"
echo -e "username: " $BB_USERNAME "\n" >> "config.yml"
echo -e "password: " $BB_PASSWORD "\n" >> "config.yml"
export RAILS_ENV=test
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed