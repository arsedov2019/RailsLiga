require 'rest-client'
require 'json'
require 'grape-swagger'

class GatewayApi < Grape::API
  mount ReservationApi
  mount PurchaseApi
  mount VisitorsApi
  mount BlackListsApi
  add_swagger_documentation
end
