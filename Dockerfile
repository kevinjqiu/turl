FROM ruby:2.5-alpine
MAINTAINER kevin@idempotent.ca
COPY [".", "/app"]
WORKDIR /app
RUN apk add --update postgresql-dev ruby-dev alpine-sdk tzdata && \
  bundle install && \
  apk del ruby-dev alpine-sdk
