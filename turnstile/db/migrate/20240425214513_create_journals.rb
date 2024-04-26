class CreateJournals < ActiveRecord::Migration[7.1]
  def change
    create_table :journals do |t|
      t.string :ticket_num
      t.string :category
      t.datetime :date
      t.string :name
      t.boolean :status
      t.boolean :is_enter
      t.integer :document_num
      
      t.timestamps
    end
  end
end
