class ReservationController < ApplicationController
  # Метод создания новой брони
  def create
    cost = CostService.new(params)
    reservations = Reservation.create!(date: params[:date],
                                       num_reservations: rand(1..1000),
                                       category: params[:category],
                                       cost: cost.cost)
    # Запланированное автоматическое удаление брони через 5 минут
    TimerDestroyJob.perform_in(5.minute,reservations.id)
    render json: {result: reservations}
  end

  # Метод удаления брони
  def destroy
    result = Reservation.find_by(num_reservations: params[:num_reservations]).destroy
    if result
      render json: {head: :no_content}
    else
      render json: {head: :not_found}
    end

  end

  def show
    result = Reservation.find_by(num_reservations: params[:num_reservations])
    if result
      render json: {result: result}
    else
      render json: {status: :not_found}
    end
  end
end
