class CreateStoresTags < ActiveRecord::Migration
  def change
    create_table :stores_tags do |t|
      t.integer :store_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :stores_tags, :store_id
    add_index :stores_tags, :tag_id
  end
end
