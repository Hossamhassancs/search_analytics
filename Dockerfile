# Dockerfile
FROM ruby:3.1.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set up the working directory
WORKDIR /myapp

# Install Bundler
RUN gem install bundler:2.4.17

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the wait-for-db.sh script
COPY wait-for-db.sh /myapp/

# Make the wait-for-db.sh script executable
RUN chmod +x /myapp/wait-for-db.sh

# Copy the ap
