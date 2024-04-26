class TimerDestroyJob
  include Sidekiq::Job

  def perform(reservations)
    reserv_destroy = Reservation.find(reservations)
    if reserv_destroy
      reserv_destroy.destroy
      puts "Reservations destroyed"
    else
      puts "No reservations found to destroy"
    end
  end
end
