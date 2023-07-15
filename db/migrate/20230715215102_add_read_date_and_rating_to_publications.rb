class AddReadDateAndRatingToPublications < ActiveRecord::Migration[7.0]
  def change
    add_column :publications, :date_read, :date
    add_column :publications, :rating, :float
  end
end
