web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers -q active_storage_analysis 
release: bundle exec rails db:migrate
