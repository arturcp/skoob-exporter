class RenameSkoobBookIdToSkoobPublicationIdInPublications < ActiveRecord::Migration[7.0]
  def change
    rename_column :publications, :skoob_book_id, :skoob_publication_id
  end
end
