class AddColumToQuantityInCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :quantity, :integer, default: 100, null: false
  end
end
