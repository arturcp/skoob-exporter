namespace :books do
  desc 'Import books from skoob and persist them in the database'
  task cleanup: :environment do
    older_or_null_books = Book.where("created_at <= ? OR created_at IS NULL", 1.day.ago)
    counter = older_or_null_books.count

    if counter > 0
      older_or_null_books.destroy_all

      message = "#{counter} books deleted by the cleanup task"
      Slack::Message.send(message)
    end
  end
end
