#!/bin/bash
gem install foreman
bundle
bundle exec rails db:create || :
bundle exec rails db:migrate
rm /app/tmp/pids/* || :
./bin/dev
