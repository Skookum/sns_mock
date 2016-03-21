FROM alpine:3.3
MAINTAINER Glenn Goodrich <glenn.goodrich@skookum.com>

ENV BUILD_PACKAGES curl-dev ruby-dev build-base openssl-dev libxml2-dev libxslt-dev libgcrypt libffi-dev git ncurses tzdata
ENV RUBY_PACKAGES ruby ruby-irb ruby-json ruby-rake ruby-io-console ruby-bundler ruby-bigdecimal

# Update the package manager
RUN apk update && \
    apk upgrade && \
    apk add bash $BUILD_PACKAGES && \
    apk add bash $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

EXPOSE 4567

RUN mkdir /app

WORKDIR /tmp
COPY Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN gem install bundler --no-rdoc --no-ri
RUN bundle install

ADD . /app
WORKDIR /app

CMD ["ruby", "index.rb"]
