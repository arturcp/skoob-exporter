require 'rubygems'
require 'mechanize'

class Skoob
  def self.fetch_books!(user)
    raise InvalidCredentialsError.new('Invalid credentials') unless user.skoob_user_id > 0

    user.import_library do |skoob_user|
      Bookshelf.new(skoob_user).read
    end
  end
end
