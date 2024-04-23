class ReservationController < ApplicationController

  def create
    render json: {result: "reservations#create"}
  end

  def destroy
    render json: {result: "reservations#destroy"}
  end

  def show
    render json: {result: "reservations#show"}
  end

end
