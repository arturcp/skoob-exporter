# frozen_string_literal: true

RSpec.describe SkoobUrls, type: :model do
  describe '.shelf_url' do
    it 'returns the correct shelf URL' do
      user_id = 123
      page = 2
      type = 'books'
      expected_url = 'https://www.skoob.com.br/v1/bookcase/books/123/shelf_id:0/page:2/limit:36'

      url = SkoobUrls.shelf_url(user_id: user_id, page: page, type: type)

      expect(url).to eq(expected_url)
    end
  end

  describe '.books_shelf_url' do
    it 'returns the correct books shelf URL' do
      user_id = 123
      page = 2
      expected_url = 'https://www.skoob.com.br/v1/bookcase/books/123/shelf_id:0/page:2/limit:36'

      url = SkoobUrls.books_shelf_url(user_id, page)

      expect(url).to eq(expected_url)
    end
  end

  describe '.comics_shelf_url' do
    it 'returns the correct comics shelf URL' do
      user_id = 123
      page = 2
      expected_url = 'https://www.skoob.com.br/v1/bookcase/comics/123/shelf_id:0/page:2/limit:36'

      url = SkoobUrls.comics_shelf_url(user_id, page)

      expect(url).to eq(expected_url)
    end
  end

  describe '.magazines_shelf_url' do
    it 'returns the correct magazines shelf URL' do
      user_id = 123
      page = 2
      expected_url = 'https://www.skoob.com.br/v1/bookcase/magazines/123/shelf_id:0/page:2/limit:36'

      url = SkoobUrls.magazines_shelf_url(user_id, page)

      expect(url).to eq(expected_url)
    end
  end

  describe '.publication_page_url' do
    it 'returns the correct publication page URL' do
      publication_slug = '/books/1234'
      expected_url = 'https://www.skoob.com.br/books/1234'

      url = SkoobUrls.publication_page_url(publication_slug)

      expect(url).to eq(expected_url)
    end
  end
end
