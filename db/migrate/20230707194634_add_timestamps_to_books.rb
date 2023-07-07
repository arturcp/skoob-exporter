class AddTimestampsToBooks < ActiveRecord::Migration[7.0]
  def change
    change_table :books do |t|
      t.timestamps null: true
    end
  end
end
