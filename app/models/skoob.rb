require 'rubygems'
require 'mechanize'

class Skoob
  def self.fetch_publications!(user)
    raise InvalidCredentialsError.new('Invalid credentials') unless user.skoob_user_id > 0

    user.import_library do |skoob_user|
      Publications.new(skoob_user).import
    end
  end
end
