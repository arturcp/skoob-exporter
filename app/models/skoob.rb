require 'rubygems'
require 'mechanize'

class Skoob
  attr_reader :user

  def initialize(email, password)
    @user = SkoobUser.login(email, password)
  end

  def fetch_books!
    raise InvalidCredentialsError.new('Invalid credentials') unless @user.skoob_user_id > 0

    @user.import_library do |user|
      Bookshelf.new(user).read
    end
  end
end
