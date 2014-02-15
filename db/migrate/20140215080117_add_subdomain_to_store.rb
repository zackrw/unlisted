class AddSubdomainToStore < ActiveRecord::Migration
  def change
    add_column :stores, :subdomain, :string
  end
end
