class PurchasedTicketsController < ApplicationController
  before_action :set_purchased_ticket, only: %i[ show update destroy ]

  # GET /purchased_tickets
  def index
    @purchased_tickets = PurchasedTicket.all

    render json: @purchased_tickets
  end

  # GET /purchased_tickets/1
  def show
    render json: @purchased_ticket
  end

  # POST /purchased_tickets
  def create
    @purchased_ticket = PurchasedTicket.new(purchased_ticket_params)

    if @purchased_ticket.save
      render json: @purchased_ticket, status: :created, location: @purchased_ticket
    else
      render json: @purchased_ticket.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /purchased_tickets/1
  def update
    if @purchased_ticket.update(purchased_ticket_params)
      render json: @purchased_ticket
    else
      render json: @purchased_ticket.errors, status: :unprocessable_entity
    end
  end

  # DELETE /purchased_tickets/1
  def destroy
    @purchased_ticket.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchased_ticket
      @purchased_ticket = PurchasedTicket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchased_ticket_params
      params.require(:purchased_ticket).permit(:ticket_number, :category, :fullname, :birthdate, :document_number, :document_type)
    end
end
