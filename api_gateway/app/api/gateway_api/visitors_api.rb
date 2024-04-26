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
        requires :ticket_num, type: Integer, desc: "Номер билета"
        requires :category, type: String, values: %w[VIP FAN], desc: "Категория билета"
        requires :document_num, type: Integer, desc: "Номер документа"
        requires :is_enter, type: Boolean, desc: "Взодим или выходим"
      end
      post do
        ticket = {
          ticket_num: 1,
          category: "VIP",
          name: "Иван Иванович Иванов",
          age: 23,
          document_num: 12345555,
          document_type: "PASSPORT"
        }

        # response = RestClient.get('http://tickets:4000/tickets',
        #                           params: { ticket_num: params[:ticket_num]})
        # JSON.parse(response.body)

        is_blocked = RestClient.get('http://turnstile:8888/black_lists', params: { ticket_num: params[:ticket_num] })

        is_blocked = JSON.parse(is_blocked.body);
        success = true

        unless is_blocked.empty?
          success = false
          is_enter = false
        else
          existing_entry = RestClient.get('http://turnstile:8888/journals', params: { ticket_num: params[:ticket_num], sort: '-date', limit: 1 })
          # is_enter = true
          existing_entry = JSON.parse(existing_entry.body);
          if existing_entry.empty? || existing_entry[:is_enter] != params[:is_enter]
            is_enter = true
          else 
            is_enter = false
            success = false
          end

          if ticket[:document_num] != params[:document_num] || ticket[:category] != params[:category]
            success = false
          end
        end

        response = RestClient.post('http://turnstile:8888/journals',
                                      {
                                        ticket_num: params[:ticket_num],
                                        category: params[:category],
                                        date: Time.now,
                                        name: ticket[:name],
                                        status: success,
                                        is_enter: is_enter,
                                        document_num: ticket[:document_num]
                                      }.to_json,
                                      { content_type: :json, accept: :json })
                                     
        JSON.parse(response.body)
      end
    end
  end
end