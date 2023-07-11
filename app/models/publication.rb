class Publication < ActiveRecord::Base
  belongs_to :skoob_user, primary_key: 'skoob_user_id'

  enum publication_type: {
    book: 0,
    comic: 1,
    magazine: 2
  }
end
