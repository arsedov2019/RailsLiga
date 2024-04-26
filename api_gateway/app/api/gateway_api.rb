require 'rest-client'
require 'json'
require 'grape-swagger'

class GatewayApi < Grape::API
  mount ReservationApi

  add_swagger_documentation
end
