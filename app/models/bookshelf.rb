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

    page = 1
    books = []
    duplicated_books = []

    while true && page <= 1 do
      puts "********** page #{page} ***********"

      url = SkoobUrls.bookshelf_read(user.skoob_user_id, page)
      data = JSON.load(open(url)).deep_symbolize_keys

      books += data[:response].map do |item|
        edition = item[:edicao]

        book = Book.new(
          skoob_user_id: @user.skoob_user_id,
          title: edition[:titulo],
          author: edition[:autor],
          publisher: edition[:editora],
          year: edition[:ano].to_i,
          skoob_book_id: edition[:id],
          isbn: fetch_isbn(edition[:url])
        )

        if Book.exists?(skoob_user_id: @user.skoob_user_id, skoob_book_id: edition[:id])
          duplicated_books << book
          puts "Book #{edition[:titulo]} already exists...".red
        else
          book.save!
          puts "#{book.title.yellow}: #{book.isbn}"
        end
      end.compact

      page += 1

      break if data[:response].empty?
    end

    {
      books: books,
      duplicated: duplicated_books
    }
  end

  def fetch_isbn(book_url)
    url = SkoobUrls.book_page_url(book_url)
    isbn = 0

    @mechanize.get(url) do |page|
      isbn = page.at('meta[property="books:isbn"]')[:content]
    end

    isbn.delete('-._')
  end
end
