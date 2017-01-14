namespace :skoob do
  desc "Import books from skoob and persist them in the database"
  task import: :environment do
    Skoob.new(ENV['USER_EMAIL'], ENV['USER_PASSWORD']).fetch_books!
  end
end
