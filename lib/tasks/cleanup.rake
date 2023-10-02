namespace :skoob do
  desc 'Delete publications older than 1 day or with null created_at'
  task cleanup: :environment do
    publications = Publication.where("created_at <= ? OR created_at IS NULL", 1.day.ago)
    counter = publications.count

    if counter > 0
      publications.destroy_all

      message = "#{counter} publications deleted by the cleanup task"
      Slack::Message.send(message)
    end
  end

  desc 'Delete user data to allow account recreation'
  task cleanup_user: :environment do
    email = ENV["EMAIL"]

    puts "Cleaning user data. Email: #{email}"

    user = SkoobUser.find_by(email: email)
    if user
      user.destroy!
    else
      puts "User not found."
    end

    puts "Done."
  end
end
