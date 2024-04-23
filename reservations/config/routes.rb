Rails.application.routes.draw do
  post "/reservations", to: "reservation#create"
  get "/cost", to: "cost#price"
end
