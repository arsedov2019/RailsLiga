class JournalsController < ApplicationController
  before_action :set_journal, only: %i[ show update destroy ]

  # GET /journals
  def index
    @journals = Journal.all

    if params[:date].present?
      @journals = @journals.where(date: params[:date])
    end

    if params[:name].present?
      @journals = @journals.where(name: params[:name])
    end

    if params[:category].present?
      @journals = @journals.where(category: params[:category])
    end

    if params[:status].present?
      @journals = @journals.where(status: params[:status])
    end

    if params[:is_enter].present?
      @journals = @journals.where(is_enter: params[:is_enter])
    end

    render json: @journals
  end

  # GET /journals/1
  def show
    render json: @journal
  end

  # POST /journals
  def create

    response = RestClient.get('http://purchase:5001/ticket',
                              params: { ticket_num: params[:ticket_num]})
    JSON.parse(response.body)


    @journal = Journal.new(journal_params)

    if @journal.save
      render json: @journal, status: :created, location: @journal
    else
      render json: @journal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /journals/1
  def update
    if @journal.update(journal_params)
      render json: @journal
    else
      render json: @journal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /journals/1
  def destroy
    @journal.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def journal_params
      params.require(:journal).permit(:ticket_num, :category, :document_num, :name, :status, :is_enter, :date)
    end
end
