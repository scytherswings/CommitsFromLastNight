#!/bin/bash
SECRETS="config/secrets.yml"
SECRET="$(bundle exec rake secret)"
rm $SECRETS
touch $SECRETS
echo -e "production:\n  secret_key_base: " $SECRET "\n" >> $SECRETS
