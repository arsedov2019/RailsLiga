require 'rest-client'
require 'json'
class GatewayApi
  class ReservationApi < Grape::API

    resource :reservations do
      desc "Получение цены бронирования"
      params do
        requires :category, type: String, desc: "Категория места"
        requires :date, type: Date, desc: "Дата бронирования"
      end


      get :price do
        response = RestClient.get("http://reservations/price",
                                  params: { category: params[:category], date: params[:date].to_s })
        JSON.parse(response.body)
      end

      desc "Создание брони"
      params do
        requires :category, type: String, desc: "Категория места"
        requires :date, type: Date, desc: "Дата бронирования"
      end

      post do
        response = RestClient.post("http://reservations:4000/reservations",
                                   { category: params[:category], date: params[:date].to_s }.to_json,
                                   { content_type: :json, accept: :json })
        JSON.parse(response.body)
      end

      desc "Отмена брони"
      params do
        requires :reservation_num, type: Integer, desc: "Номер бронирования"
      end
      delete do
        response = RestClient.delete("http://reservations:4000/reservations",
                                     params: { reservation_num: params[:reservation_num] })
        JSON.parse(response.body)
      end

      desc "Получение созданной брони"
      params do
        requires :reservation_num, type: Integer, desc: "Номер бронирования"
      end

      get do
        response = RestClient.get("http://reservations:4000/reservations",
                                  params: { reservation_num: params[:reservation_num] })
        JSON.parse(response.body)
      end
    end
  end
end
