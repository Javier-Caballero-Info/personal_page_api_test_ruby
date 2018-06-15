FROM node:9.11.1

USER root

RUN apt-get update -y

RUN apt-get install ruby ruby-dev build-essential cpp -y

RUN gem install bundler

RUN gem install unf_ext --no-ri --no-rdoc

RUN gem install rspec

RUN npm i -g xunit-viewer

WORKDIR /usr/src/app

COPY Gemfile ./

COPY Gemfile.lock ./

RUN bundle install

COPY . .