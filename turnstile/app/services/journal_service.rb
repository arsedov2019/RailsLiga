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


    # Если нет в заблокированных билетах, тогда проверим данные посетителя 
    # А также заходил ли он уже, если да, то не пускаем
    if success

      existing_entry = Journal.where(status:true, ticket_num: params[:ticket_num]).order(date: :desc).first
      is_enter = existing_entry.nil? || existing_entry.is_enter != params[:is_enter]

      unless is_enter
        success = false
      end


      if ticket["document_number"] != params[:document_num] || ticket["category"] != params[:category]
        success = false
      end

    end

    # Cоздаем запись
    journal_params = {
      ticket_num: params[:ticket_num],
      category: params[:category],
      date: Time.now,
      name: ticket["fullname"],
      status: success,
      is_enter: params[:is_enter],
      document_num: params[:document_num]
    }


    journal = Journal.new(journal_params)
  end
end