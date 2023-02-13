#!/bin/bash
bundle exec rails db:create || :
bundle exec rails db:migrate
rm /app/tmp/pids/* || :
bundle exec rails s -b 0.0.0.0
