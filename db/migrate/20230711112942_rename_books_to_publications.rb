class RenameBooksToPublications < ActiveRecord::Migration[7.0]
  def change
    rename_table :books, :publications
  end
end
