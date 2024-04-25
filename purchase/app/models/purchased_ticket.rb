class PurchasedTicket < ApplicationRecord
  enum category: %w[vip fan], validate: true
  enum document_type: %w[паспорт свидетельство права], validate: true
  validates :event_date, :fullname, :birthdate, :document_number
end
