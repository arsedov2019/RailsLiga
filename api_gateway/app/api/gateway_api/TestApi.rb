class GatewayApi
  class TestApi<Grape::API
    desc 'Test'

    get do
      present "Test gateway"
    end
  end
end