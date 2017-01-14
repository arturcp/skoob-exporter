class SkoobUrls
  SKOOB_URL = 'https://www.skoob.com.br'

  def self.bookshelf_read(user_id, page = 1)
    "#{SKOOB_URL}/v1/bookcase/books/#{user_id}/shelf_id:0/page:#{page}/"
  end

  def self.book_page_url(book_slug)
    "#{SKOOB_URL}/#{book_slug}"
  end
end
