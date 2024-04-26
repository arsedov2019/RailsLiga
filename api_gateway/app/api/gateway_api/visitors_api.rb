require 'rest-client'
require 'json'

class GatewayApi
  class VisitorsApi < Grape::API
    format :json

    namespace :visitors do
      
      desc "Получить отчет по переданным параметрам"
      params do
        optional :date, type: Date, desc: "Дата и время прохода"
        optional :name, type: String, desc: "ФИО"
        optional :category, type: String, values: %w[VIP FAN], desc: "Категория билета"
        optional :status, type: Boolean, desc: "Статус прохода"
        optional :is_enter, type: Boolean, desc: "Вошел или вышел"
      end
      get do
        params_hash = params || {}
      
        params_to_send = {
          date: params_hash[:date],
          name: params_hash[:name],
          category: params_hash[:category],
          status: params_hash[:status],
          is_enter: params_hash[:is_enter]
        }.compact
      
        response = RestClient.get('http://turnstile:8888/journals', params: params_to_send)
      
        JSON.parse(response.body)
      end

      desc "Регистрация входа/выхода посетителей"
      params do
        requires :ticket_num, type: String, desc: "Номер билета"
        requires :category, type: String, values: %w[VIP FAN], desc: "Категория билета"
        requires :document_num, type: Integer, desc: "Номер документа"
        requires :is_enter, type: Boolean, desc: "Взодим или выходим"
      end
      post do

        response = RestClient.post('http://turnstile:8888/journals',
                                      {
                                        ticket_num: params[:ticket_num],
                                        category: params[:category],
                                        date: Time.now,
                                        name: nil,
                                        status: nil,
                                        is_enter: nil,
                                        document_num: params[:document_num]
                                      }.to_json,
                                      { content_type: :json, accept: :json })
                                     
        JSON.parse(response.body)
      end
    end
  end
end