require 'rubygems'
require 'mechanize'

class Skoob
  def initialize(email, password)
    @user = SkoobUser.new(email, password).login
  end

  def fetch_books!
    Bookshelf.new(@user).read
  end
end
