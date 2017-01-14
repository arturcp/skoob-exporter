class CreateSkoobUser < ActiveRecord::Migration[5.0]
  def change
    create_table :skoob_users do |t|
      t.string :email
      t.integer :skoob_user_id
      t.integer :last_imported_page, default: 1
    end
  end
end
