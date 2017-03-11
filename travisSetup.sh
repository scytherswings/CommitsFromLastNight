#!/bin/bash
SECRETS="config/secrets.yml"
SECRET="$(bundle exec rake secret)"
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# rm $SECRETS
echo -e "test:\n  secret_key_base: " $BOGUS "\n" >> $SECRETS
touch "config.yml"
echo -e "username: " $BB_USERNAME "\n" >> "config.yml"
echo -e "password: " $BB_PASSWORD "\n" >> "config.yml"
export RAILS_ENV=test
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed