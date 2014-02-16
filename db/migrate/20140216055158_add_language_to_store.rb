class AddLanguageToStore < ActiveRecord::Migration
  def change
    add_column :stores, :language, :integer
  end
end
