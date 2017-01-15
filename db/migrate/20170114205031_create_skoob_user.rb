class CreateSkoobUser < ActiveRecord::Migration[5.0]
  def change
    create_table :skoob_users do |t|
      t.string :email
      t.integer :skoob_user_id
      t.integer :import_status, default: 0
      t.jsonb :not_imported, default: {}, null: false
    end
  end
end
