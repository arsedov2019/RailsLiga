class CostService

  def initialize(params)
    @params = params
  end

  # Основной метод расчёта стоимости
  def cost
    # Получаем количество проданных билетов
    @tickets_sold = tickets_sold
    # Находим категорию по параметру категории
    category = Category.find_by(category: @params[:category])
    # Вычисляем процент проданных билетов от общего количества
    sold_percentage = (@tickets_sold.to_f / category.quantity) * 100
    # Определяем увеличение цены на основе процента продаж
    price_increase = (sold_percentage / 10).floor
    # Расчитываем итоговую цену с учётом увеличения
    final_price = category.c_cost * (1.1 ** price_increase)
  end

  private

  # Метод для получения количества проданных билетов
  def tickets_sold
    # Запрос к сервису покупки для получения количества купленных билетов
    response = RestClient.get("http://purchase:5001/count_purchased_ticket", {
      params: {
        category: @params[:category],
        event_date: @params[:date],
      }
    })

    # Парсим ответ и возвращаем количество билетов
    result = JSON.parse(response.body)
    result["count_ticket"].to_i
  end

end