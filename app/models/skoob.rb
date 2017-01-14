require 'rubygems'
require 'mechanize'

class Skoob
  def initialize(email, password)
    @user = SkoobUser.login(email, password)
  end

  def fetch_books!
    Bookshelf.new(@user).read
  end
end
