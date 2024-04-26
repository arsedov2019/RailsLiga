class BlackListsController < ApplicationController
  before_action :set_black_list, only: %i[ show update destroy ]

  # GET /black_lists
  def index
    @black_lists = BlackList.all

    if params[:ticket_num].present?
      @black_lists = @black_lists.where(ticket_num: params[:ticket_num])
    end

    render json: @black_lists
  end

  # GET /black_lists/1
  def show
    render json: @black_list
  end

  # POST /black_lists
  def create
    @black_list = BlackList.new(black_list_params)

    if @black_list.save
      render json: @black_list, status: :created, location: @black_list
    else
      render json: @black_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /black_lists/1
  def update
    if @black_list.update(black_list_params)
      render json: @black_list
    else
      render json: @black_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /black_lists/1
  def destroy
    @black_list.destroy!
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_black_list
      @black_list = BlackList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def black_list_params
      params.require(:black_list).permit(:ticket_num, :document_num)
    end
end
