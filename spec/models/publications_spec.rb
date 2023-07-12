# frozen_string_literal: true

RSpec.describe Publications do
  let(:user) { create(:skoob_user, skoob_user_id: '123') }
  let(:mechanize) { instance_double('Mechanize') }
  let(:book) { create(:publication, publication_type: :book, title: 'My Book', skoob_user: user) }
  let(:comic) { create(:publication, publication_type: :comic, title: 'My Comic Book', skoob_user: user) }
  let(:magazine) { create(:publication, publication_type: :magazine, title: 'My Magazine', skoob_user: user) }
  # let(:publications_data) { { response: [], paging: { total: 0 } } }

  subject { described_class.new(user) }

  before do
    allow(user).to receive(:mechanize).and_return(mechanize)
    allow(subject).to receive(:fetch_books!).and_return({
      publications: [book],
      duplicated: []
    })
    allow(subject).to receive(:fetch_comics!).and_return({
      publications: [comic],
      duplicated: []
    })
    allow(subject).to receive(:fetch_magazines!).and_return({
      publications: [magazine],
      duplicated: []
    })
  end

  describe '#import' do
    context 'when the user has a skoob_user_id' do
      it 'imports publications and returns the result' do
        expect(subject).to receive(:calculate_total_publications)

        result = subject.import

        expected_publication_titles = ["My Book", "My Comic Book", "My Magazine"]
        expect(result[:publications].map(&:title)).to eq(expected_publication_titles)
      end
    end

    context 'when the user does not have a skoob_user_id' do
      it 'does not import publications and returns an empty array' do
        expect(user).to receive(:skoob_user_id).and_return(nil)

        result = subject.import

        expect(result).to eq([])
      end
    end
  end

  describe '#calculate_total_publications' do
    it 'updates the user with the total publications count' do
      expect(SkoobUrls).to receive(:books_shelf_url).with(user.skoob_user_id).and_return('https://example.com/books')
      expect(SkoobUrls).to receive(:comics_shelf_url).with(user.skoob_user_id).and_return('https://example.com/comics')
      expect(SkoobUrls).to receive(:magazines_shelf_url).with(user.skoob_user_id).and_return('https://example.com/magazines')
      expect(subject).to receive(:count_publications_from_shelf).with('https://example.com/books').and_return(10)
      expect(subject).to receive(:count_publications_from_shelf).with('https://example.com/comics').and_return(5)
      expect(subject).to receive(:count_publications_from_shelf).with('https://example.com/magazines').and_return(3)
      expect(user).to receive(:update).with(publications_count: 18)

      subject.send(:calculate_total_publications)
    end
  end

  describe '#count_publications_from_shelf' do
    let(:shelf_url) { 'https://example.com/shelf' }
    let(:data) { { paging: { total: 5 } } }

    it 'returns the total count from the shelf' do
      expect(subject).to receive(:read_url).with(shelf_url).and_return(data)

      count = subject.send(:count_publications_from_shelf, shelf_url)

      expect(count).to eq(5)
    end
  end

  describe '#fetch_isbn' do
    let(:book_url) { 'https://example.com/book' }
    let(:publication_page_url) { 'https://example.com/publication' }
    let(:page) { instance_double('Mechanize::Page') }

    before do
      allow(SkoobUrls).to receive(:publication_page_url).with(book_url).and_return(publication_page_url)
      allow(mechanize).to receive(:get).with(publication_page_url).and_yield(page)
      allow(page).to receive(:at).with('meta[property="books:isbn"]').and_return({ content: '123-456-789' })
    end

    it 'fetches and cleans the ISBN from the publication page' do
      isbn = subject.send(:fetch_isbn, book_url)

      expect(isbn).to eq('123456789')
    end

    it 'returns 0 if an error occurs during the ISBN fetching' do
      allow(mechanize).to receive(:get).with(publication_page_url).and_raise(StandardError)

      isbn = subject.send(:fetch_isbn, book_url)

      expect(isbn).to eq(0)
    end
  end

  describe '#read_url' do
    let(:url) { 'https://example.com/data' }
    let(:response) { double(body: '{}') }
    let(:data) { { response: {}, paging: {} } }

    before do
      allow(RestClient).to receive(:get).with(url).and_return(response)
      allow(JSON).to receive(:load).with(response.body).and_return(data)
    end

    it 'reads the URL and parses the response as JSON' do
      result = subject.send(:read_url, url)

      expect(result).to eq(data)
    end
  end
end
