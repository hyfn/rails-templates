namespace :db do
  desc 'bounce the db'
  task bounce: :environment do
    puts 'dropping...'
    Rake::Task['db:drop'].execute
    puts 'creating...'
    Rake::Task['db:create'].execute
    puts 'migrating...'
    Rake::Task['db:migrate'].execute
  end
end
