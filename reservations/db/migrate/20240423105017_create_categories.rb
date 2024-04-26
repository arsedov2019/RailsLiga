class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.integer :c_cost
      t.string :category

      t.timestamps
    end
  end
end
