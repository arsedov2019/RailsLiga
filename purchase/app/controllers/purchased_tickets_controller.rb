class PurchasedTicketsController < ApplicationController

  # GET /purchased_tickets/1
  # Информация о билете по его номеру.
  def show
    ticket = PurchasedTicket.find_by(ticket_number: params[:ticket_number])
    if result
      render json: ticket #, only: [:ticket_number, :category, :event_date, :fullname, :birthdate, :document_number, :document_type]
    else
      render json: {head: :not_found}
    end
  end

  # GET /purchased_tickets/count?category=&event_date=
  # Информация о купленных дилетах на определенную дату и категорию.
  def count_ticket
    unless @category.include?(params[:category])
      render json: {head: :bad_request}
    end
    tickets = count_tickets_bu_date_category(params[:category], params[:event_date])
    render json: {count_ticket: tickets}
  end

  # POST /purchased_tickets?
  # Покупка билета.
  def create
    if params[:num_reservations].nil?
      render json: {head: :bad_request, error: "Params number reservations is empty"}
      return
    end
    response = RestClient.get('http://reservations:4000/price',
                              params: { category: params[:category], date: params[:event_date].to_s })
    result = JSON.parse(response.body)
    unless result
      render json: {head: :bad_request, error: "There is no such number reservations"}
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
      render json: {head: :bad_request, errors: ticket.errors.objects.all.select(:full_message)}
      return
    end
    birthdate = Date.parse(params[:birthdate].gsub(/, */, '-') )
    if (birthdate + 13.years > Date.Today)
      render json: {head: :bad_request, error: "Билет не доступен к покупке пользователям младше 13."}
      return
    end
    event_date = Date.parse(params[:event_date].gsub(/, */, '-') )
    ticket[ticket_number] = count_tickets_bu_date_category(params[:category], event_date).to_s + params[:category] + event_date.day.to_s + event_date.month.to_s
    render json: {head: :created, ticket: ticket}
  end


  # это явно можно было бы как-то по умному сделать.
  private
  @category = ["vip", "fan"]

  def count_tickets_bu_date_category(category, event_date)
    PurchasedTicket.select(|t| t[:category] == category && t[:event_date] == event_date).size
  end
end
