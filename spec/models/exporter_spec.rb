# frozen_string_literal: true

RSpec.describe Exporter do
  let(:skoob_user) { create(:skoob_user) }
  let!(:publications) { [create(:publication, title: 'Book 1', author: 'Author 1', isbn: '1234567890', publisher: 'Publisher 1', year: 2022, skoob_user: skoob_user)] }

  describe '#generate_csv' do
    it 'generates the CSV file with the correct data' do
      exporter = Exporter.new(skoob_user.skoob_user_id)
      expected_csv = "Title,Author,ISBN,My Rating,Average Rating,Publisher,Binding,Year Published,Original Publication Year,Date Read,Date Added,Bookshelves,My Review\n" \
                     "Book 1,Author 1,1234567890,,,Publisher 1,,2022,2022,,,,\n"

      csv_data = exporter.generate_csv

      expect(csv_data).to eq(expected_csv)
    end
  end
end
