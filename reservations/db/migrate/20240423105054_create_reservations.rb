class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.date :date
      t.integer :num_reservations
      t.integer :num_ticket
      t.integer :cost

      t.timestamps
    end
  end
end
