class PurchasedTicketsController < ApplicationController

  # GET /purchased_tickets?ticket_number=1
  # Информация о билете по его номеру.
  def show
    ticket = PurchasedTicket.find_by(ticket_number: params[:ticket_number])
    if ticket
      render json: ticket #, only: [:ticket_number, :category, :event_date, :fullname, :birthdate, :document_number, :document_type]
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
    tickets = count_tickets_bu_date_category(params[:category], params[:event_date])
    render json: {count_ticket: tickets}
  end

  # POST /purchased_tickets?
  # Покупка билета.
  def create
    if params[:num_reservations].nil?
      render status: :bad_request, json: {error: :bad_request, description: "Params number reservations is empty"}
      return
    end
    response = RestClient.get('http://reservations:4000/price',
                              params: { category: params[:category], date: params[:event_date].to_s })
    result = JSON.parse(response.body)
    unless result
      render status: :bad_request, json: {error: :bad_request, description: "There is no such number reservations"}
      return
    end
    unless check_category(params[:category])
      render status: :bad_request, json: {error: :bad_request, description: "Params category invalid"}
      return
    end
    ticket = PurchasedTicket.create(
      category: params[:category],
      category: params[:event_date],
      category: params[:fullname],
      category: params[:birthdate],
      category: params[:document_number],
      category: params[:document_type]
      )
    if ticket.invalid?
      render status: :bad_request, json: {name: :bad_request, errors: ticket.errors.objects.all.select(:full_message)}
      return
    end
    birthdate = date_parse(params[:birthdate])
    unless birthdate
      render status: :bad_request, json: {error: :bad_request, description: "Params birthdate invalid"}
      return
    end
    if (birthdate + 13.years > Date.Today)
      render status: :bad_request, json: {head: :bad_request, error: "Билет не доступен к покупке пользователям младше 13."}
      return
    end

    event_date = date_parse(params[:event_date])
    unless event_date
      render status: :bad_request, json: {error: :bad_request, description: "Params event date invalid"}
      return
    end

    ticket[ticket_number] = count_tickets_bu_date_category(params[:category], event_date).to_s + params[:category] + event_date.day.to_s + event_date.month.to_s
    render status: :created, json: {head: :created, ticket: ticket}
  end


  # это явно можно было бы как-то по умному сделать.
  private
  Category = ["vip", "fan"]

  def count_tickets_bu_date_category(category, event_date)
    PurchasedTicket.select{|t| t[:category] == category && t[:event_date] == event_date}.size
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
