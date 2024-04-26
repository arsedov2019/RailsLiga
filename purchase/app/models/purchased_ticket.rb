class PurchasedTicket < ApplicationRecord
  validate :event_date, :fullname, :birthdate, :document_number
end
