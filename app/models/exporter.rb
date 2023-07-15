require 'csv'

class Exporter
  def initialize(skoob_user_id)
    @skoob_user_id = skoob_user_id
  end

  def generate_csv
    header = ['Title', 'Author', 'ISBN', 'My Rating', 'Average Rating',
        'Publisher', 'Binding', 'Year Published', 'Original Publication Year',
        'Date Read', 'Date Added', 'Bookshelves', 'My Review']

    publications = Publication.where(skoob_user_id: @skoob_user_id)

    CSV.generate(headers: true) do |csv|
      csv << header

      publications.each do |publication|
        rating = publication.rating > 0 ? publication.rating : nil

        csv << [publication.title, publication.author, publication.isbn, rating, nil,
          publication.publisher, nil, publication.year, publication.year,
          publication.date_read, nil, nil, nil]
      end
    end
  end
end
