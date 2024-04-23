class ReservationController < ApplicationController

  def create
    cost = CostService.new(params)
    reservations = Reservation.create!(date: params[:date],
                                       num_reservations: rand(1..1000),
                                       category: params[:category],
                                       cost: cost.cost)
    TimerDestroyJob.perform_in(1.minute,reservations.id)
    render json: {result: reservations}
  end


  def destroy
    Reservation.find(params[:id]).destroy
    render json: {head: :no_content}
  end

  def show
    render json: {result: "reservations#show"}
  end



end
