class CreateBlackLists < ActiveRecord::Migration[7.1]
  def change
    create_table :black_lists do |t|
      t.integer :ticket_num
      t.integer :document_num

      t.timestamps
    end
  end
end