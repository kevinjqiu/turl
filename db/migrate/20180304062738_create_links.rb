class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.string :original, limit: 2083
      t.string :shortened

      t.timestamps
    end
    add_index :links, :original
    add_index :links, :shortened
  end
end
