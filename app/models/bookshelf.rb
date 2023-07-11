require 'open-uri'

class Bookshelf
  attr_reader :user, :books

  def initialize(user)
    @mechanize = user.mechanize
    @user = user
  end

  def read
    return [] unless user.skoob_user_id.present?

    calculate_total_publications

    books_data = fetch_books!
    comics_data = fetch_comics!
    magazines_data = fetch_magazines!

    {
      books: books_data[:books] + comics_data[:books] + magazines_data[:books],
      duplicated: books_data[:duplicated] + comics_data[:duplicated] + magazines_data[:duplicated]
    }
  end

  private

  def calculate_total_publications
    books_url = SkoobUrls.books_shelf_url(user.skoob_user_id)
    books_total = count_publications_from_shelf(books_url)

    comics_url = SkoobUrls.comics_shelf_url(user.skoob_user_id)
    comics_total = count_publications_from_shelf(comics_url)

    magainzes_url = SkoobUrls.magazines_shelf_url(user.skoob_user_id)
    magazines_total = count_publications_from_shelf(magainzes_url)

    user.update(books_count: books_total + comics_total + magazines_total)
  end

  def count_publications_from_shelf(shelf_url)
    data = read_url(shelf_url)
    data.dig(:paging, :total).to_i
  end

  def fetch_books!
    fetch_publications!(:books)
  end

  def fetch_comics!
    fetch_publications!(:comics)
  end

  def fetch_magazines!
    fetch_publications!(:magazines)
  end

  # Type can be: :books, :comics, :magazines
  def fetch_publications!(type)
    puts "\n\n============= Fetching #{type.to_s.cyan} =============\n\n"
    page = 1
    publications = []
    duplicated_publications = []

    url = SkoobUrls.bookshelf_url(user_id: user.skoob_user_id, page: page, type: type)
    data = read_url(url)

    while true do
      puts "PAGE #{page}"

      publications += data[:response].map do |item|
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
          duplicated_publications << book
          puts "Book #{edition[:titulo]} already exists...".red
        else
          book.save!
          puts "#{book.title.yellow}: #{book.isbn}"
        end
      end.compact

      page += 1

      url = SkoobUrls.bookshelf_url(user_id: user.skoob_user_id, page: page, type: type)
      data = read_url(url)

      break if data[:response].empty?
    end

    {
      books: publications,
      duplicated: duplicated_publications
    }
  end

  def fetch_isbn(book_url)
    url = SkoobUrls.book_page_url(book_url)
    isbn = 0

    @mechanize.get(url) do |page|
      isbn = page.at('meta[property="books:isbn"]')[:content]
    end

    isbn.delete('-._')
  rescue
    0
  end

  def read_url(url)
    response = RestClient.get(url)
    data = JSON.load(response.body).deep_symbolize_keys
  end
end
