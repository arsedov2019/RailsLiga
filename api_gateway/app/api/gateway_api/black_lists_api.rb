require 'rest-client'
require 'json'

class GatewayApi
  class BlackListsApi < Grape::API

    namespace :black_lists do

      desc "Получение билета по номеру"
      params do
       requires :ticket_num, type: Integer 
      end
      get do
        response = RestClient.get('http://turnstile:8888/black_lists',
                                  params: { ticket_num: params[:ticket_num]})
        JSON.parse(response.body)
      end

      desc "Блокирование билета"
      params do
        requires :ticket_num, type: Integer, desc: "Номер билета"
        requires :document_num, type: Integer, desc: "Номер документа"
      end
      post do
        response = RestClient.post('http://turnstile:8888/black_lists',
                                  { ticket_num: params[:ticket_num], document_num: params[:document_num] }.to_json,
        content_type: :json, accept: :json)
        JSON.parse(response.body)
      end
    end
  end
end