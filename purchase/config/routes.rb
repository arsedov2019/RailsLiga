Rails.application.routes.draw do

  get '/purchased_ticket', to: 'purchased_tickets#show'
  get '/count_purchased_ticket', to: 'purchased_tickets#count_ticket'
  post '/buy_ticket', to: 'purchased_tickets#create'
end
