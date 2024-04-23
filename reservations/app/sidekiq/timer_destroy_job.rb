class TimerDestroyJob
  include Sidekiq::Job

  def perform(reservations)

    Reservation.find(reservations).destroy!
    puts "reservations destroy"
  end
end
