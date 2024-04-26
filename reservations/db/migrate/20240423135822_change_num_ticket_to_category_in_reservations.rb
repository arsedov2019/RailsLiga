class ChangeNumTicketToCategoryInReservations < ActiveRecord::Migration[7.0]
  def change
    rename_column :reservations, :num_ticket, :category
    change_column :reservations, :category, :string
  end
end
