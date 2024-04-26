Rails.application.routes.draw do
  # Бронирование
  # Создание новой брони
  post "/reservations", to: "reservation#create"

  # Удаление брони
  delete "/reservations", to: "reservation#destroy"

  # Показать детали одной брони
  get "/reservations", to: "reservation#show"

  # Стоимость
  # Получение информации о стоимости
  get "/price", to: "cost#price"
end
