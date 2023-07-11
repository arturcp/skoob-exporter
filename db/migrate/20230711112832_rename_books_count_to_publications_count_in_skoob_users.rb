class RenameBooksCountToPublicationsCountInSkoobUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :skoob_users, :books_count, :publications_count
  end
end
