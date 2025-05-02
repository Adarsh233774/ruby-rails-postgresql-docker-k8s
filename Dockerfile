 FROM ruby:3.2.2

 # dep
 RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
 RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
     && apt-get install -y nodejs \
     && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
     && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
     && apt-get update && apt-get install -y yarn

 WORKDIR /app

 COPY Gemfile Gemfile.lock ./
 RUN bundle install

 COPY . .

 ENV SECRET_KEY_BASE=f921a340fc496b38b61841c6806ea526cabb673822c6bb64581f5a72ad389b4f096be0422e95dadc1d8545452c8ad76f5598b496457e8dcfa3d0c07b072b4403

 RUN RAILS_ENV=production bundle exec rake assets:precompile

 EXPOSE 3000

 CMD ["rails", "server", "-b", "0.0.0.0"]
