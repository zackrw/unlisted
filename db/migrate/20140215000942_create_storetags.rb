class CreateStoretags < ActiveRecord::Migration
  def change
    create_table :storetags do |t|
      t.int :store_id
      t.int :tag_id

      t.timestamps
    end
    add_index :storetags, :store_id
    add_index :storetags, :tag_id
  end
end
