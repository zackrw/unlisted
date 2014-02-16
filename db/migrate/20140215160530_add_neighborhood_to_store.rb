class AddNeighborhoodToStore < ActiveRecord::Migration
  def change
    add_column :stores, :neighborhood, :string
  end
end
