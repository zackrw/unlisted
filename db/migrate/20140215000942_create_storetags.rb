class CreateStoretags < ActiveRecord::Migration
  def change
    create_table :storetags do |t|
      t.int :store_id
      t.int :tag_id

      t.timestamps
    end
  end
end
