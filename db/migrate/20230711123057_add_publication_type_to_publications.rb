class AddPublicationTypeToPublications < ActiveRecord::Migration[7.0]
  def change
    add_column :publications, :publication_type, :integer, default: 0
  end
end
