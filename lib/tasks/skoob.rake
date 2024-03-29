namespace :skoob do
  desc 'Import publications from skoob and persist them in the database'
  task import: :environment do
    require 'io/console'

    puts 'Skoob Credentials:'
    puts '==================='
    print 'email: '
    email = STDIN.gets.chomp
    print 'password (typing will be hidden): '
    password = STDIN.noecho(&:gets)
    puts

    begin
      user = SkoobUser.login(email, password)
      Skoob.fetch_publications!(user)

      puts
      puts "Done! Your Skoob ID is #{skoob.user.skoob_user_id.to_s.green}"
      puts
      puts 'To generate your CSV file, run:'
      puts "bin/rake skoob:csv:generate #{skoob.user.skoob_user_id}".green
    rescue InvalidCredentialsError => e
      puts
      puts "Something went wrong :( Check your credentials and try again.".red
    end
  end

  namespace :csv do
    desc 'Generate csv with skoob data to be imported on Goodreads'
    task generate: :environment do
      ARGV.each { |a| task a.to_sym do ; end }

      puts "Generating CSV for user #{ARGV[0]}"
      puts Exporter.new(ARGV[1]).generate_csv
      puts 'done'
    end
  end
end
