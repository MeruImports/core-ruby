FROM ruby:3.2.3-alpine

RUN apk update && apk add --no-cache build-base bash

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY core.gemspec /app/core.gemspec
COPY lib/core/version.rb /app/lib/core/version.rb

RUN bundle install

COPY . /app
