Rails.application.routes.draw do
  resources :purchased_tickets

  get '/purchased_tickets/:ticket_number', to: 'patients#show'
end
