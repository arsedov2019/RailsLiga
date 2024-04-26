class JournalService
  def self.create_journal(params)
    # Есть ли в листе блокировок
    is_blocked = BlackList.find_by(ticket_num: params[:ticket_num])
    success = is_blocked == nil
    p " success 0 "
    p success
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
      p " success "
      p success

      existing_entry = Journal.where(ticket_num: params[:ticket_num]).order(date: :desc).first
      is_enter = existing_entry.nil? || existing_entry.is_enter != params[:is_enter]
      p " success 2 "
      p success
      p existing_entry

      unless is_enter
        success = false
      end
      p " success 3"
      p success

      if ticket["document_number"] != params[:document_num] || ticket["category"] != params[:category]
        success = false
      end

      p " success 4 "
      p success
    end

    # Cоздаем запись
    journal_params = {
      ticket_num: ticket["ticket_number"],
      category: ticket["category"],
      date: Time.now,
      name: ticket["fullname"],
      status: success,
      is_enter: params[:is_enter],
      document_num: ticket["document_number"]
    }


    journal = Journal.new(journal_params)
  end
end