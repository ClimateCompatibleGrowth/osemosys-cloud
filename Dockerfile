FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y yarn postgresql-client tmux htop nodejs glpk-utils coinor-cbc zip python3-pandas
RUN mkdir /osemosys-cloud
WORKDIR /osemosys-cloud
COPY Gemfile /osemosys-cloud/Gemfile
COPY Gemfile.lock /osemosys-cloud/Gemfile.lock
RUN bundle install
COPY . /osemosys-cloud
CMD ["/bin/sh"]
