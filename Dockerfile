FROM ruby:2.5.1

RUN apt-get update \
  && apt-get install --yes --no-install-recommends mysql-client \
  && rm -rf /var/lib/apt/lists/*

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /app

COPY \
  Gemfile \
  Gemfile.lock \
  /app/
RUN bundle install --jobs=4 --path=/bundle \
  && mkdir -p /app/tmp/cache \
  && mkdir -p /app/tmp/pids \
  && mkdir -p /app/tmp/sockets

COPY . /app
