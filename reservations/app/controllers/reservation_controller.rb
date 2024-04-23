class ReservationController < ApplicationController

  def create
    reservations = Reservation.create!(date: params[:date],
                                       num_reservations: rand(1..1000),
                                       category: params[:category],
                                       cost: CostService.cost)
    render json: {result: "reservations#create"}
  end


  def destroy
    render json: {result: "reservations#destroy"}
  end

  def show
    render json: {result: "reservations#show"}
  end



end
