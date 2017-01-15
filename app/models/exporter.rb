require 'csv'

class Exporter
  def initialize(skoob_user_id)
    @skoob_user_id = skoob_user_id
  end

  def generate_csv
    header = ['Title', 'Author', 'ISBN', 'My Rating', 'Average Rating',
        'Publisher', 'Binding', 'Year Published', 'Original Publication Year',
        'Date Read', 'Date Added', 'Bookshelves', 'My Review']

    books = Book.where(skoob_user_id: @skoob_user_id)

    CSV.generate(headers: true) do |csv|
      csv << header

      books.each do |book|
        csv << [book.title, book.author, book.isbn, nil, nil,
          book.publisher, nil, book.year, book.year,
          nil, nil, nil, nil]
      end
    end
  end
end
