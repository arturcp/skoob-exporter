require 'open-uri'

class Publications
  attr_reader :user, :publications

  def initialize(user)
    @mechanize = user.mechanize
    @user = user
  end

  def import
    return [] unless user.skoob_user_id.present?

    calculate_total_publications

    books_data = fetch_books!
    comics_data = fetch_comics!
    magazines_data = fetch_magazines!

    {
      publications: books_data[:publications] + comics_data[:publications] + magazines_data[:publications],
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

    user.update(publications_count: books_total + comics_total + magazines_total)
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

    url = SkoobUrls.shelf_url(user_id: user.skoob_user_id, page: page, type: type)
    data = read_url(url)

    while true do
      puts "PAGE #{page}"

      publications += data[:response].map do |item|
        edition = item[:edicao]

        publication = Publication.new(
          skoob_user_id: @user.skoob_user_id,
          title: edition[:titulo],
          author: edition[:autor],
          publisher: edition[:editora],
          year: edition[:ano].to_i,
          skoob_publication_id: edition[:id],
          isbn: fetch_isbn(edition[:url]),
          publication_type: Publication.publication_types[type.to_s.singularize],
          date_read: item[:dt_leitura].to_s.split(' ')[0],
          rating: item[:ranking]
        )

        if Publication.exists?(skoob_user_id: @user.skoob_user_id, skoob_publication_id: edition[:id])
          duplicated_publications << publication
          puts "Publication #{edition[:titulo]} already exists...".red
        else
          publication.save!
          puts "#{publication.title.yellow}: #{publication.isbn}"
        end
      end.compact

      page += 1

      url = SkoobUrls.shelf_url(user_id: user.skoob_user_id, page: page, type: type)
      data = read_url(url)

      break if data[:response].empty?
    end

    {
      publications: publications,
      duplicated: duplicated_publications
    }
  end

  def fetch_isbn(book_url)
    url = SkoobUrls.publication_page_url(book_url)
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
