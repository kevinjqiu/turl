FROM ruby:2.5-alpine
MAINTAINER kevin@idempotent.ca
RUN apk add --update postgresql-dev ruby-dev alpine-sdk tzdata
COPY [".", "/app"]
WORKDIR /app
RUN bundle install
