class CreatePurchasedTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :purchased_tickets do |t|
      t.string :ticket_number
      t.string :category
      t.date :event_date
      t.string :fullname
      t.date :birthdate
      t.string :document_number
      t.string :document_type

      t.timestamps
    end
  end
end
