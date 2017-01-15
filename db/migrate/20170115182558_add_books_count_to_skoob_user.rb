class AddBooksCountToSkoobUser < ActiveRecord::Migration[5.0]
  def change
    add_column :skoob_users, :books_count, :integer, default: 0
  end
end
