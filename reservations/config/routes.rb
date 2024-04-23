Rails.application.routes.draw do
  # Бронирование
  # Создание новой брони
  post "/reservations", to: "reservations#create"

  # Удаление брони
  delete "/destroy", to: "reservations#destroy"

  # Показать детали одной брони
  get "/reservation", to: "reservations#show"

  # Стоимость
  # Получение информации о стоимости
  get "/price", to: "costs#price"
end
