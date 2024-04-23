class GatewayApi<Grape::API
  add_swagger_documentation
  format :json
  mount TestApi
end