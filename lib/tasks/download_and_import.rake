namespace :db do
  task download_and_import: :environment do
    raise unless Rails.env.development?

    local_database = Rails.configuration.database_configuration.fetch(Rails.env).fetch('database')

    puts 'Downloading backup to disk'
    `heroku pg:backups:capture`
    `heroku pg:backups:download`
    puts "Restoring backup to #{local_database}"
    `createdb #{local_database}`
    `pg_restore --no-owner --clean -d #{local_database} latest.dump`
    puts 'Removing local backup'
    `rm latest.dump`
    puts 'Done'
  end
end
