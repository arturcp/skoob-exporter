require 'open-uri'

class Bookshelf
  PAGE_LIMIT = 2

  attr_reader :user, :books

  def initialize(user)
    @mechanize = user.mechanize
    @user = user
    @books = []
  end

  def read
    fetch_books!
  end

  private

  def fetch_books!
    page = 1

    while true && page < PAGE_LIMIT do
      puts "********** page #{page} ***********"

      url = SkoobUrls.bookshelf_read(user.id, page)
      data = JSON.load(open(url)).deep_symbolize_keys

      @books += data[:response].map do |book|
        Book.new(book[:edicao])
      end

      page += 1

      break if data[:response].empty?
    end

    books_with_isbn
  end

  def books_with_isbn
    @books.map do |book|
      url = "#{SkoobUrls::SKOOB_URL}/#{book.url}"

      @mechanize.get(url) do |page|
        puts "Reading isbn from #{url}"
        book.isbn = page.at('meta[property="books:isbn"]')[:content]
        puts "#{book.title}: #{book.isbn}"
      end
    end
  end
end
