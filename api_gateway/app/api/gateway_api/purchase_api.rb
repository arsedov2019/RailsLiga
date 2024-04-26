require 'rest-client'
require 'json'
class GatewayApi
  class PurchaseApi < Grape::API

    resource :purchase do
      desc "Получение информации о количестве купленных билетов."
      params do
        requires :category, type: String, desc: "Категория места"
        requires :event_date, type: Date, desc: "Дата бронирования"
      end


      get :count do
        response = RestClient.get('http://purchase:5001/count_purchased_ticket',
                                  params: { category: params[:category], event_date: params[:event_date].to_s })
        JSON.parse(response.body)
      end

      desc "Получение купленного билета"
      params do
        requires :ticket_number, type: String, desc: "Номер билета"
      end

      get do
        response = RestClient.get("http://purchase:5001/ticket",
                                  params: { ticket_number: params[:ticket_number] })
        JSON.parse(response.body)
      end

      desc "Покупка билета"
      params do
        requires :num_reservations, type: Integer, desc: "Номер брони"
        requires :category, type: String, desc: "Категория места"
        requires :event_date, type: Date, desc: "Дата бронирования"
        requires :fullname, type: String, desc: "ФИО"
        requires :birthdate, type: Date, desc: "Дата рождения"
        requires :document_number, type: String, desc: "Номер и серия документа"
        requires :document_type, type: String, desc: "Тип документа"
      end


      post do
        response = RestClient.post("http://purchase:5001/buy_ticket",
                                  params: { num_reservations: params[:num_reservations],
                                            category: params[:category],
                                            event_date: params[:event_date],
                                            fullname: params[:fullname],
                                            birthdate: params[:birthdate],
                                            document_number: params[:document_number],
                                            document_type: params[:document_type]})
        JSON.parse(response)
      end
    end
  end
end
