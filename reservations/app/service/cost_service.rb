class CostService

  def initialize(params)
    @params = params
    @tickets_sold = tickets_sold
  end
  def cost
    category = Category.find_by(category: @params[:category])
    sold_percentage = (@tickets_sold.to_f / category.quantity) * 100
    price_increase = (sold_percentage / 10).floor
    final_price = category.c_cost * (1.1 ** price_increase)
  end

  private

  def tickets_sold
  RestClient.get("http://СЕРВИС ПО ПОКУПКЕ:5000/tickets", {  #ЗАМЕНИТЬ
      params: {
        category: @params[:category],
        date: @params[:date],
      }
    }).to_i
  end


end