FROM ruby:2.6.2
RUN apt-get update -qq && apt-get install -y yarn postgresql-client tmux htop nodejs glpk-utils coinor-cbc
RUN mkdir /osemosys-cloud
WORKDIR /osemosys-cloud
COPY Gemfile /osemosys-cloud/Gemfile
COPY Gemfile.lock /osemosys-cloud/Gemfile.lock
RUN bundle install
COPY . /osemosys-cloud
CMD ["/bin/sh"]
