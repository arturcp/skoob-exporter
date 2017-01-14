class CreateBook < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.integer :skoob_user_id
      t.string :title
      t.string :author
      t.string :isbn
      t.string :publisher
      t.integer :year
      t.integer :skoob_book_id
    end
  end
end
