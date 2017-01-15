namespace :skoob do
  desc "Import books from skoob and persist them in the database"
  task import: :environment do
    Skoob.new(ENV['USER_EMAIL'], ENV['USER_PASSWORD']).fetch_books!
  end

  namespace :csv do
    desc "Generate csv with skoob data to be imported on Good Reads"
    task generate: :environment do
      ARGV.each { |a| task a.to_sym do ; end }

      puts "Generating CSV for user #{ARGV[0]}"
      puts Exporter.new(ARGV[1]).generate_csv
      puts "done"
    end
  end
end
