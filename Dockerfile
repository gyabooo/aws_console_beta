FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y nodejs build-essential
ENV APP_NAME aws-console-beta
RUN mkdir /${APP_NAME}
WORKDIR /${APP_NAME}
COPY Gemfile /${APP_NAME}/Gemfile
COPY Gemfile.lock /${APP_NAME}/Gemfile.lock
RUN bundle install
COPY . /${APP_NAME}

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}
ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV}

RUN rails db:create

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
