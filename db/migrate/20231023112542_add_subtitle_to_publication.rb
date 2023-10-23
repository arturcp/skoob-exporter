class AddSubtitleToPublication < ActiveRecord::Migration[7.0]
  def change
    add_column :publications, :subtitle, :string
  end
end
