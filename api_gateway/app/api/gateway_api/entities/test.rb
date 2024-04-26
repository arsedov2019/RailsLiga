class GatewayApi
  module Entities
    class Test < Grape::Entities
      expose :id, documentation: { type: 'Integer', desc: 'Идентификатор ВМ', required: true }
    end
  end
end