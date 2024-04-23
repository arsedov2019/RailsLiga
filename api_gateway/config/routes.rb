Rails.application.routes.draw do
  mount GrapeSwaggerRails::Engine => '/swagger'

  mount GatewayApi => '/api'

end
