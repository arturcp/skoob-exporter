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
        csv << [publication.title, publication.author, publication.isbn, nil, nil,
          publication.publisher, nil, publication.year, publication.year,
          nil, nil, nil, nil]
      end
    end
  end
end
