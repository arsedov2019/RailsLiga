class CostController < ApplicationController

  def price
    cost = CostService.new(params)
    render json: {result: cost.cost}
  end

end
