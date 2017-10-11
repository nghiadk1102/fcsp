namespace :db do
  desc "auto synchronize data"
  task synchronize: :environment do
    puts "let sync by API"
  end
end
