# Create runtime environment
FROM nginx:alpine AS runtime

# Configure, as necessary

# Create build environment
FROM ruby:alpine3.10 AS build

# Configure workdir
WORKDIR /var/app

# Add build dependencies
RUN apk add --update alpine-sdk && \
    gem install bundler

# Copy code
COPY Gemfile* ./

# Resolve dependencies
RUN bundle install

COPY ./ ./

# Perform build
RUN bundle exec jekyll build --trace

# Enter back into runtime environment
FROM runtime

# Copy code with built dependencies
COPY --from=build /var/app/_site /usr/share/nginx/html