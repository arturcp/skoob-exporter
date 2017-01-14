require 'open-uri'

class Bookshelf
  attr_reader :user, :books

  def initialize(user)
    @mechanize = user.mechanize
    @user = user
  end

  def read
    fetch_books!
  end

  private

  def fetch_books!
    return [] unless user.skoob_user_id.present?

    page = user.last_imported_page
    books = []

    while true do
      puts "********** page #{page} ***********"

      url = SkoobUrls.bookshelf_read(user.skoob_user_id, page)
      data = JSON.load(open(url)).deep_symbolize_keys

      books += data[:response].map do |book|
        edition = book[:edicao]

        unless Book.exists?(skoob_user_id: @user.skoob_user_id, skoob_book_id: edition[:id])
          Book.create!(
            skoob_user_id: @user.skoob_user_id,
            title: edition[:titulo],
            author: edition[:autor],
            publisher: edition[:editora],
            year: edition[:ano].to_i,
            skoob_book_id: edition[:id],
            isbn: fetch_isbn(edition[:titulo], edition[:url])
          )
        end
      end.compact

      page += 1

      break if data[:response].empty?
    end

    books
  end

  def fetch_isbn(book_title, book_url)
    url = SkoobUrls.book_page_url(book_url)
    isbn = 0

    @mechanize.get(url) do |page|
      puts "Reading isbn from #{url}"
      isbn = page.at('meta[property="books:isbn"]')[:content]
      puts "#{book_title}: #{isbn}"
    end

    isbn
  end
end
