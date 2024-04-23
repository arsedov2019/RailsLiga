class CostController < ApplicationController
  def price
    render json: {result: "cost#price"}
  end
end
