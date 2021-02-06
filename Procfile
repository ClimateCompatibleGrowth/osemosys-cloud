web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers -q active_storage_analysis -q active_storage_purge -q low_priority
release: bundle exec rails db:migrate
