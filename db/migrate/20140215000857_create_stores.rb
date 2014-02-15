class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :phone
      t.string :name
      t.string :slogan
      t.string :status
      t.string :location
      t.string :city
      t.string :country
      t.string :category_id
      t.float :latitude
      t.float :longitude
      t.json :hours

      t.timestamps
    end
    add_index :stores, :category_id
  end
end
