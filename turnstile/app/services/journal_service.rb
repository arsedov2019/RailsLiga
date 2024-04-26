class JournalService
  def self.create_journal(params)
    # Есть ли в листе блокировок
    is_blocked = BlackList.find_by(ticket_num: params[:ticket_num])
    success = is_blocked.nil?

    # Проверяем есть ли такой билет 
    response = RestClient.get('http://purchase:5001/ticket', params: { ticket_number: params[:ticket_num] })
    ticket = JSON.parse(response.body)

    # ticket = {
    #       ticket_num: 1,
    #       category: "VIP",
    #       name: "Иван Иванович Иванов",
    #       age: 23,
    #       document_num: 12345555,
    #       document_type: "PASSPORT",
    #       date: Date.today
    #     }

    # Если нет в заблокированных билетах, тогда проверим данные посетителя 
    # А также заходил ли он уже, если да, то не пускаем
    if success
      existing_entry = Journal.where(ticket_num: params[:ticket_num]).order(date: :desc).first
      is_enter = existing_entry.nil? || existing_entry.is_enter != params[:is_enter]

      unless is_enter
        success = false
      end

      if ticket[:document_num] != params[:document_num] || ticket[:category] != params[:category]
        success = false
      end
    end

    # И создаем запись
    journal_params = {
      ticket_num: ticket[:ticket_num],
      category: ticket[:category],
      date: Time.now,
      name: ticket[:name],
      status: success,
      is_enter: params[:is_enter],
      document_num: ticket[:document_num]
    }

    journal = Journal.new(journal_params)
  end
end