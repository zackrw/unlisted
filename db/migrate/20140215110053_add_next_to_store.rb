class AddNextToStore < ActiveRecord::Migration
  def change
    add_column :stores, :next, :integer
  end
end
