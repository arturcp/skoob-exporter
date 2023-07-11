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
end
