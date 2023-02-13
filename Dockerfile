FROM ruby:3.2.1

WORKDIR /app

ENV RAILS_SERVE_STATIC_FILES=true
CMD ./bin/entrypoint.sh
