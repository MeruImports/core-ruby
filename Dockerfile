FROM ruby:3.2.3

RUN apt-get clean
RUN apt-get update -qq

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY core.gemspec /app/core.gemspec
COPY lib/core/version.rb /app/lib/core/version.rb

RUN gem install bundler
RUN bundle install

COPY . /app
