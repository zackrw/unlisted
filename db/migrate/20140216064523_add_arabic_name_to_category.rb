class AddArabicNameToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :arabic_name, :string
  end
end
