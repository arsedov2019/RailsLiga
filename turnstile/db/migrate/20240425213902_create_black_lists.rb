class CreateBlackLists < ActiveRecord::Migration[7.1]
  def change
    create_table :black_lists do |t|
      t.string :ticket_num
      t.string :document_num

      t.timestamps
    end
  end
end
