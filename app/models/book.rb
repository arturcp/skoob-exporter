class Book < ActiveRecord::Base
  belongs_to :skoob_user, primary_key: 'skoob_user_id'
end
