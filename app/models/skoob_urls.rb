class SkoobUrls
  SKOOB_URL = 'https://www.skoob.com.br'

  def self.shelf_url(user_id:, page: 1, type:)
    "#{SKOOB_URL}/v1/bookcase/#{type}/#{user_id}/shelf_id:0/page:#{page}/limit:36"
  end

  def self.books_shelf_url(user_id, page = 1)
    shelf_url(user_id: user_id, page: page, type: 'books')
  end

  def self.comics_shelf_url(user_id, page = 1)
    shelf_url(user_id: user_id, page: page, type: 'comics')
  end

  def self.magazines_shelf_url(user_id, page = 1)
    shelf_url(user_id: user_id, page: page, type: 'magazines')
  end

  def self.publication_page_url(publication_slug)
    "#{SKOOB_URL}#{publication_slug}"
  end
end
