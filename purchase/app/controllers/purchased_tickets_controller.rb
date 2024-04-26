class PurchasedTicketsController < ApplicationController

  # GET /purchased_tickets?ticket_number=1
  # Информация о билете по его номеру.
  def show
    ticket = PurchasedTicket.find_by(ticket_number: params[:ticket_number])
    if ticket
      render json: ticket
    else
      render status: :not_found, json: {head: :not_found, error: "Билет с таким номером не найден."}
    end
  end

  # GET /purchased_tickets/count?category=&event_date=
  # Информация о купленных дилетах на определенную дату и категорию.
  def count_ticket
    unless check_category(params[:category])
      render status: :bad_request, json: {error: :bad_request, description: "Params category invalid"}
      return
    end
    unless date_parse(params[:event_date])
      render status: :bad_request, json: {error: :bad_request, description: "Params event date invalid"}
      return
    end
    tickets = count_tickets_bu_date_category(params[:category], params[:event_date])  #?
    render json: {count_ticket: tickets}
  end

  # POST /purchased_tickets?
  # Покупка билета.
  def create
    @params = params[:params]
    if @params[:num_reservations].nil?
      render status: :bad_request, json: {error: :bad_request, description: "Params number reservations is empty"}
      return
    end
    response = RestClient.get("http://reservations:4000/reservations",
                              params: { num_reservations: @params[:num_reservations] })
    result = JSON.parse(response.body)

    if result.has_key? 'status'
      render status: :bad_request, json: {error: :bad_request, description: "There is no such number reservations"}
      return
    end

    result_hash = result["result"]

    birthdate = date_parse(@params[:birthdate])

    unless birthdate
      render status: :bad_request, json: {error: :bad_request, description: "Params birthdate invalid"}
      return
    end

    if (birthdate + 13.years > Date.today)
      render status: :bad_request, json: {head: :bad_request, error: "Билет не доступен к покупке пользователям младше 13."}
      return
    end

    if PurchasedTicket.where(event_date: result_hash["date"],
                             document_number: @params[:document_number],
                             document_type: @params[:document_type]).size != 0
      render status: :bad_request, json: {error: :bad_request, description: "Нou have already bought a ticket for this day."}
      return
    end

    event_date = date_parse(result_hash["date"])
    ticketN = count_tickets_bu_date_category(result_hash["category"], event_date).to_s + result_hash["category"] + event_date.day.to_s + event_date.month.to_s

    ticket = PurchasedTicket.create(
      ticket_number: ticketN.to_s,
      category: result_hash["category"],
      event_date: result_hash["date"],
      fullname: @params[:fullname],
      birthdate: @params[:birthdate],
      document_number: @params[:document_number],
      document_type: @params[:document_type]
    )

    if ticket.invalid?
      render status: :bad_request, json: {name: :bad_request, errors: ticket.errors.objects.all.select(:full_message)}
      return
    end

    RestClient.delete("http://reservations:4000/reservations",
                      params: { num_reservations: @params[:num_reservations] })

    render status: :created, json: {head: :created, ticket: ticket}
  end


  # это явно можно было бы как-то по умному сделать. =(
  private
  Category = ["VIP", "FAN"]

  def count_tickets_bu_date_category(category, event_date)
    #PurchasedTicket.select{|t| t[:category] == category && t[:event_date] == event_date}.size
    PurchasedTicket.where(category:category,event_date: event_date).size
  end

  def check_category(category)
    Category.include?(category)
  end

  def date_parse(date)
    begin
      Date.parse(date.gsub(/, */, '-') )
    rescue ArgumentError, NoMethodError
      false
    end
  end
end
