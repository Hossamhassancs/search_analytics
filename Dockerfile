# Dockerfile
FROM ruby:3.1.0

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /myapp

RUN gem install bundler:2.4.17

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY wait-for-db.sh /myapp/

RUN chmod +x /myapp/wait-for-db.sh

