#!/bin/bash
SECRET="$(bundle exec rake secret)"
export SECRET_KEY_BASE=$SECRET
